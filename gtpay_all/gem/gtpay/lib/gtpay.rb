require 'gtpay/transaction'
require 'gtpay/request'
require 'gtpay/response'

module Gtpay
  class << self

    attr_reader :gtpay_merc_id
    attr_writer :api_endpoint, :requery_url, :form_submit_url, :logging
    attr_accessor :gtpay_hash_key

    # Base URL for the Gtpay
    def api_endpoint
      @api_endpoint ||= 'https://ibank.gtbank.com'
    end

    def requery_url
      @requery_url ||= "#{api_endpoint}/GTPayService/gettransactionstatus.json"
    end

    def form_submit_url
      @form_submit_url ||= "#{api_endpoint}/GTPay/Tranx.aspx"
    end

    def logging
      @logging.nil? ? false : @logging
    end

    # TODO: Track getting set nil abruptly
    def gtpay_merc_id=(merc_id)
      puts "Setting Gtpay Merc id: #{merc_id}"
      raise "Can't set Nil or Blank" if merc_id.blank?
      @gtpay_merc_id = merc_id
      puts "Done Setting Gtpay Merc id: #{merc_id}"
    end

    # Set configuration options using a block
    def configure
      yield self
    end

    def requery(transaction_id, amount)
      request = Gtpay::Request.new(:get, requery_url, request_params(transaction_id, amount))
      response = request.send_request
    end

    def request_params(transaction_id, amount)
      {
        tranxid: transaction_id,
        mertid: gtpay_merc_id,
        amount: amount,
        hash: Digest::SHA512.hexdigest("#{ gtpay_merc_id }#{ transaction_id }#{ gtpay_hash_key }")
      }
    end

  end
end
