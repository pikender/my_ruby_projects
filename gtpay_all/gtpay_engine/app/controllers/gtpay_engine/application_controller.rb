module GtpayEngine
  class ApplicationController < ActionController::Base
    def home
    end

    def new
      render 'gtpay_engine/transactions/auto_submit_gtpay_forms'
    end
  end
end
