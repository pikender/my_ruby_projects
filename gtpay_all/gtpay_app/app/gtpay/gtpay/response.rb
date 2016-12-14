module Gtpay
  class Response

    attr_reader :code, :status, :message, :gateway, :tranx_id, :currency, :amount, :other_data, :merchant_ref

    def initialize(response)
      json = JSON.parse(response) rescue response
      @tranx_id = json['gtpay_tranx_id']
      @code = json['gtpay_tranx_status_code'] || json['ResponseCode']
      @message = json['gtpay_tranx_status_msg'] || json['ResponseDescription']
      @gateway = json['gtpay_gway_name']
      @amount = (json['gtpay_tranx_amt_small_denom'] || json['Amount']).to_f rescue nil
      @currency = json['gtpay_tranx_curr']
      @status = response.code if response.respond_to?(:code)
      @merchant_ref = json['MerchantReference']
    end

    def success?
      @code == '00'
    end

    def amount_matches?(amount)
      @amount == amount.to_f
    end

    def ok?
      @status == 200
    end
  end
end
