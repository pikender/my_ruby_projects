module Gtpay
  class Transaction < ActiveRecord::Base

    self.table_name = 'gt_pay_transactions'

    STATUS = { unsuccessful: 0, successful: 1, pending: 2 }

    scope :successful, -> { where(status: STATUS[:successful]) }
    scope :unsuccessful, -> { where(status: STATUS[:unsuccessful]) }
    scope :pending, -> { where(status: STATUS[:pending]) }

    validates :gtpay_tranx_id, :presence => true
    validates :gtpay_cust_id, :presence => true
    validates :gtpay_tranx_id, :uniqueness => true

    # TODO: Make class_name configurable
    belongs_to :user, class_name: 'User', foreign_key: :gtpay_cust_id

    before_validation :assign_values, :on => :create

    def assign_values
      # convert to two decimal float number
      self.gtpay_tranx_amt = gtpay_tranx_amt.round(2) rescue nil
      # Assign transaction id
      self.gtpay_tranx_id = SecureRandom.hex(6) unless gtpay_tranx_id?
      self.status = STATUS[:pending]
    end

    def successful?
      status == STATUS[:successful]
    end

    def unsuccessful?
      status == STATUS[:unsuccessful]
    end

    def pending?
      status == STATUS[:pending]
    end

    def gtpay_tranx_amt_in_cents
      String((gtpay_tranx_amt.to_f*100).to_i)
    end

    def update_details
      return true unless pending?
      response = Gtpay.requery(gtpay_tranx_id, gtpay_tranx_amt_in_cents)
      handle_response(response)
    end

    private

    def handle_response(response)
      set_transaction_attributes(response)
    end

    def set_transaction_attributes(response)
      self.gtpay_tranx_status_msg = response.message
      self.gtpay_tranx_status_code = response.code
      self.card_type = response.gateway if response.gateway
      self.merchant_ref = response.merchant_ref if response.merchant_ref
      self.status = get_status(response)
      save!
    end

    def get_status(response)
      if response.success? && response.amount_matches?(gtpay_tranx_amt_in_cents)
        STATUS[:successful]
      elsif response.success?
        self.gtpay_tranx_status_msg = "Amount Paid is not correct"
        STATUS[:unsuccessful]
      else
        STATUS[:unsuccessful]
      end
    end
  end
end
