Gem::Specification.new do |s|
  s.name        = "gtpay"
  s.version     = '0.0.1'
  s.platform    = 'ruby'
  s.authors     = ["Pikender Sharma"]
  s.email       = "pikender@vinsol.com"
  s.homepage    = "https://github.com/pikender/gtpay"
  s.summary     = "gtpay-0.0.1"
  s.description = "Integrate GTPay"

  s.rubygems_version   = "RUBYGEMS_VERSION"
  s.rubyforge_project  = "RUBYFORGE_PAGE"

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.extra_rdoc_files = [ "README.md" ]
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_path     = "lib"
  
  s.add_runtime_dependency('activerecord', '3.2.16')
  s.add_runtime_dependency('httparty')
  
  s.add_development_dependency('rake', '10.3.2')
  s.add_development_dependency('sqlite3', '1.3.9')
#  s.add_development_dependency('shoulda-matchers')
  s.add_development_dependency('rspec', '2.13.0')
  s.add_development_dependency('bundler', '1.6.1')

end
