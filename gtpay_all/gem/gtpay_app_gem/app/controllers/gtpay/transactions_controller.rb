# encoding: UTF-8
module Gtpay
  class TransactionsController < ApplicationController

    # NOTE: Authenticate user
    skip_before_filter :verify_authenticity_token, :only => :callback
    before_filter :find_transaction, only: [:callback]

    def create
      @transaction = Gtpay::GtPayTransaction.new(:gtpay_tranx_amt => 200, :gtpay_tranx_id => session[:gtpay_tranx_id], :gtpay_tranx_curr => "566")
      @transaction.user = User.first
      @transaction.order = Order.first
      session[:gtpay_tranx_id] = nil
      if @transaction.save
        render layout: false
      else
        redirect_to_gtpay_online_payment_mode(@transaction.errors.full_messages.to_sentence)
      end
    end

    def callback
      handle_gtpay_response!
    end

    #--------------------------------------------------
    private

    def redirect_to_gtpay_online_payment_mode(msg)
      redirect_to(home_index_path, flash: {notice: msg}) and return
    end

    def handle_gtpay_response!
      @transaction.update_details
      if @transaction.status?
        @success = 'Transaction has been confirmed successfully'
      else
        @error = "Transaction was not successful. Reason: #{ @transaction.gtpay_tranx_status_msg }"
      end

      @try_other_option = "Are you having troubles using this payment method? Try our other payment channels"  if @error
      @gt_pay_response = true

      @order = @transaction.order
      if @order && @order.status_released?
        redirect_to_gtpay_online_payment_mode("Success Order. #{@success}")
      elsif @order && @order.status_cancelled?
        redirect_to_gtpay_online_payment_mode("Cancelled Order. #{@error}")
      else
        redirect_to_gtpay_online_payment_mode("Unknow Order State. #{@error}")
      end
    end

    def find_transaction
      if @transaction = Gtpay::GtPayTransaction.where(:gtpay_tranx_id => params['gtpay_tranx_id']).first
        @transaction.update_column(:card_type, params[:gtpay_gway_name]) if params[:gtpay_gway_name].present?
        (redirect_to_gtpay_online_payment_mode('This transaction has already been processed.') and return) unless @transaction.pending?
      else
        flash[:error] = "Invalid Request!"
        redirect_to_gtpay_online_payment_mode('Invalid request')
      end
    end
  end
end
