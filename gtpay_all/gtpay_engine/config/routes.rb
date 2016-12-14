GtpayEngine::Engine.routes.draw do
  post 'transactions/callback' => 'transactions#callback', as: :callback_gtpay_transactions
  post 'transactions' => 'transactions#create', as: :gtpay_transactions

  get '/home' => 'application#home', as: :home_index
  get '/home/new' => 'application#new'

  root to: 'application#home'
end
