Gem::Specification.new do |s|
  s.name        = "try_gem"
  s.version     = '0.0.1'
  s.platform    = 'ruby'
  s.authors     = ["Pikender Sharma"]
  s.email       = "pikender.sharma@gmail.com"
  s.homepage    = "https://github.com/pikender/selenium-relaunch-browser"
  s.summary     = "rspec-0.0.1"
  s.description = "Gem"

  s.rubygems_version   = "1.3.7"
  s.rubyforge_project  = "try_gem"

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.extra_rdoc_files = [ "README.md" ]
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_path     = "lib"
  s.add_runtime_dependency 'rake'
  s.add_runtime_dependency 'selenium-webdriver'
  s.add_runtime_dependency 'capybara'
end

