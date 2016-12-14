Rails.application.routes.draw do

  mount GtpayEngine::Engine => "/gtpay_engine"
end
