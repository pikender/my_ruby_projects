module Gtpay
  module Generators
    class ModelGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path("../../templates", __FILE__)

      def create_gtpay_support_model
        template "models/gt_pay_transaction.rb",
                 "app/models/gtpay/gt_pay_transaction.rb"
      end

      def copy_migration
        migration_template "migrations/001_create_gtpay_transaction.rb",
                           "db/migrate/create_gtpay_transaction.rb"
      end

      def self.next_migration_number(path)
        @migration_number = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i.to_s
      end
    end
  end
end
