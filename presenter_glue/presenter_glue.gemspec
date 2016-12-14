Gem::Specification.new do |s|
  s.name        = "presenter_glue"
  s.version     = '0.0.1'
  s.platform    = 'ruby'
  s.authors     = ["Pikender Sharma"]
  s.email       = "pikender@vinsol.com"
  s.homepage    = "http://github.com/pikender"
  s.summary     = "presenter_glue-0.0.1"
  s.description = "A simplified way to glue presenter methods to its domain object"

  s.license = 'Mozilla Public License 2.0 (MPL-2.0)'

  s.rubygems_version   = "RUBYGEMS_VERSION"
  s.rubyforge_project  = "RUBYFORGE_PAGE"

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec}/*`.split("\n")
  #s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  #s.extra_rdoc_files = [ 'README.md' ]
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_path     = "lib"
  s.add_dependency 'activesupport', '>= 3.0'
end

