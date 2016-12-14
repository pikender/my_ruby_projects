module Gtpay
  module Generators
    class ControllersGenerator < Rails::Generators::Base

      desc <<-DESC
        Copy Gtpay Controller
      DESC

      source_root File.expand_path("../../templates", __FILE__)

      def create_controller
        template "controllers/transactions_controller.rb",
                 "app/controllers/gtpay/transactions_controller.rb"
      end

      def create_controller_spec
        template "spec/gtpay_transactions_controller_spec.rb",
                 "spec/controllers/gtpay_transactions_controller_spec.rb"
      end

      def copy_views
        directory "views",
                  "app/views/gtpay"
      end

      def add_route
        route <<-ROUTE_CONTENT
namespace :gtpay do
  resources :transactions, :only => [:create] do
    post :callback, on: :collection
  end
end
        ROUTE_CONTENT
      end
    end
  end
end
