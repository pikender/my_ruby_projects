module Gtpay
  module Generators
    class InstallGenerator < Rails::Generators::Base

      source_root File.expand_path("../../templates", __FILE__)

      def create_gtpay_initializer
        template 'initializers/gtpay.rb', 'config/initializers/gtpay.rb'
      end
    end
  end
end
