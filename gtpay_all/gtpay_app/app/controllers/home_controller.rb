class HomeController < ApplicationController
  def index
  end

  def new
    render 'gtpay/transactions/auto_submit_gtpay_forms'
  end
end
