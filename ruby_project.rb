unless ARGV.size == 1
  puts "Please give the project_name"
  exit(1)
end

## project_name
project_name = ARGV[0].downcase

## Create Project Dir
Dir.mkdir(project_name)

## Show Current Dir
Dir.pwd

## Changeto Project Dir
Dir.chdir(project_name)

## Create lib Dir
Dir.mkdir("lib")

## Create spec Dir
Dir.mkdir("spec")

## Create spec Dir
Dir.mkdir("spec/support")

## Create project_exec file
project_exec = File.open("#{project_name}.rb", "w")
project_exec.puts(%Q(require '#{project_name}_helper.rb'))
project_exec.puts
project_exec.close


## Create project_exec helper file
project_exec_helper = File.open("#{project_name}_helper.rb", "w")
project_exec_helper.close

## Create README file
readme = File.open("README", "w")
readme.close

## Create Gemfile file
gemfile = File.open("Gemfile", "w")
gemfile.puts(%q(source 'http://rubygems.org'))
gemfile.puts
gemfile.puts(%q(gem 'rspec'))
gemfile.close

## Create Rakefile file
rakefile = File.open("Rakefile", "w")
rakefile.puts(%q(require 'rubygems'))
rakefile.puts(%q(require 'rspec/core/rake_task'))
rakefile.puts
rakefile.puts(%q(RSpec::Core::RakeTask.new(:spec) do |t|))
rakefile.puts(%q(  t.rspec_opts = ['--colour', '--format documentation']))
rakefile.puts(%q(end))
rakefile.puts
rakefile.puts(%q(desc "Default build will run specs"))
rakefile.puts(%q(task :default => :spec))
rakefile.close

## Create spec_helper file
spec_helper = File.open("spec/spec_helper.rb", "w")
spec_helper.puts(%Q(require '#{project_name}_helper.rb'))
spec_helper.puts
spec_helper.puts(%q(Dir["./spec/support/**/*.rb"].each {|f| require f}))
spec_helper.close

## Create .gitignore
gitignore_file = File.open(".gitignore", "w")
gitignore_file.close


## Show Final Structure
system("ls -lR .")
