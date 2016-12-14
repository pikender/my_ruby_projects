Scaffoldhub::Specification.new do

  # Github URL where you will post your scaffold - the specified folder must contain this file
  base_url  'https://github.com/pikender/UploadExcel'

  # The name of your new scaffold: should be a single word
  name 'uploadExcel'

  # Metadata about this scaffold - these values are only used for display on scaffoldhub.org:
  metadata do

    # A short paragraph describing what this scaffold does
    description 'The upload_excel scaffold.'

    # 4x3 aspect ratio screen shot
    screenshot 'upload_excel_screenshot.png'

    # Tag(s) to help scaffoldhub.org users find your scaffold
    tag 'upload'
    tag 'excel'

    # Optionally specify an example of a scaffold parameter
    # parameter_example 'FIELD_NAME'

    # Optionally post a link to an article you write explaining how the scaffold works.
    blog_post 'https://github.com/pikender/UploadExcel/wiki/what-and-how-to-use'
  end

  # Define a model template - this ERB file will be used to generate a new
  # model class with this path & filename: app/models/NAME.rb
  model 'templates/model.rb'

  # Define an ActiveRecord migration template - this ERB file will be used to generate a new
  # migration class with this path & filename: db/migrate/TIMESTAMP_create_PLURAL_NAME.rb
  migration 'templates/migration.rb'

  # Define a controller template - this ERB file will be used to generate a new
  # controller class with this path & filename: app/controllers/PLURAL_NAME.rb
  controller 'templates/controller.rb'

  # You can use "with_options" to specify the same source folder for a series of templates:
  # You can also specify the same destination folder using the :dest option,
  # or just use the :src and :dest options on each keyword.
  with_options :src => 'templates' do
    view '_form.html.erb'
    view '_import_msg.html.erb'
    view 'index.html.erb'
  end

  # Other keywords available are:

  # Define any other generic template - this ERB file will be used to generate
  # a new file - the dest option is required to indicate where to put the new file
  # template 'xyz.html.erb', :dest => 'path/to/xyz.html'

  # Copy any file without running an ERB transformation
  # Copy any file without running an ERB transformation
  ## To-Do :: Need to find a way to create shared directory if not present
  file 'templates/index.xls.rxls', :dest => 'app/views/shared'

  # Add a gem to the Gemfile
  gem 'spreadsheet', '0.6.5.4'
  gem 'fastercsv', '1.5.4'
  gem 'activerecord-import', ">= 0.2.0"
  gem 'excel_rails', '0.1.3'

  post_install_message <<MESSAGE


**********************************************************************************************
Please run "bundle install" to install the new gems added to your Gemfile.\n
Then run "rake db:migrate" to create your new database table.\n
Then run your Rails server and open http://localhost:3000/PLURAL_NAME to see the index page.\n 
You can click "Sample Template" to download an empty Excel file, and then upload it again after 
entering some data for each of your model's fields.\n 
See: https://github.com/pikender/UploadExcel/wiki/what-and-how-to-use for more information.\n
**********************************************************************************************
MESSAGE

end
