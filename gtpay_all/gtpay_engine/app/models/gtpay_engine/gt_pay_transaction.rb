class GtpayEngine::GtPayTransaction < Gtpay::Transaction

  attr_accessible :gtpay_tranx_amt, :gtpay_tranx_id, :gtpay_tranx_curr

  cattr_reader :per_page
  @@per_page = 20

  REQUERY_TIME = 30.minutes
  MINIMUM_AMT = 25

  # TODO: Make class_name configurable
  belongs_to :order, class_name: 'Order'

  before_save :credit_user_with_gtpay_tranx_amt, if: Proc.new { |tranx| tranx.status_changed? && (!tranx.order || (tranx.order && tranx.order.status != Order::STATUS[:incomplete])) }

  after_save :deliver_transaction_status_email, if: Proc.new { |tranx| tranx.status_changed? }

  before_save :create_order_or_credit_user_with_gtpay_tranx_amt, :if => Proc.new{ |tranx| tranx.status_changed? && tranx.order && tranx.order.status_incomplete? }

  scope :before, ->(time) { where('created_at < ?', time) }

  def self.search(query, options)
    options.merge!(:joins => :user)
    options.merge!(:conditions => ['users.firstname LIKE :query OR users.firstname LIKE :query OR  gt_pay_transactions.gtpay_tranx_id LIKE :query OR gt_pay_transactions.created_at LIKE :query OR gt_pay_transactions.gtpay_tranx_amt LIKE :query', {query: "%#{query}%" }]) if query.present?
    paginate(options)
  end

  def successfull?
    successful?
  end

  def unsuccessfull?
    unsuccessful?
  end

  def self.requery_pending_transactions
    end_time = Time.current - REQUERY_TIME
    pending.before(end_time).each do |transaction|
      transaction.update_details
    end
  end

  def gtpay_hash(callback_endpoint)
    Digest::SHA512.hexdigest("#{ gtpay_tranx_id }#{ gtpay_tranx_amt_in_cents }#{ callback_endpoint }#{ Gtpay.gtpay_hash_key }")
  end

  private

  # NOTE: Send Success / Failure Mails
  def deliver_transaction_status_email
    case status
    when STATUS[:successful]
      Rails.logger.info "Send Gtpay Success Mail : #{id}"
    when STATUS[:unsuccessful]
      Rails.logger.info "Send Gtpay Failure Mail : #{id}"
    end
  end

  def create_order_or_credit_user_with_gtpay_tranx_amt
    ActiveRecord::Base.uncached do
      if gtpay_tranx_amt >= order.tranx_amount
        if successful?
          create_payment_transaction_or_cancel_order
        elsif unsuccessful?
          cancel_as_incomplete_order
        end
      else
        cancel_as_incomplete_order
        credit_user_with_gtpay_tranx_amt
      end
    end
  end

  def credit_user_with_gtpay_tranx_amt
    Rails.logger.info "Refund Gtpay Amount : #{id}"
  end


  def create_payment_transaction_or_cancel_order
    Rails.logger.info "Gtpay Success : Mark Order as Released"
    Gtpay::GtPayTransaction.transaction(:requires_new => true) do
      order.status = Order::STATUS[:released]
      order.save!
    end
  rescue => e
    Rails.logger.info "Gtpay Success : Mark Order as Released - Failed"
    raise e 
    order.cancel!
    credit_user_with_gtpay_tranx_amt
  end

  def cancel_as_incomplete_order
    order.cancel!
  end
end
