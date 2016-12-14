module PresenterGlue
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def create_presenters_dir
        empty_directory('app/presenters')
      end
    end
  end
end
