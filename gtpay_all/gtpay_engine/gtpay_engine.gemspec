$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "gtpay_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "gtpay_engine"
  s.version     = GtpayEngine::VERSION
  s.authors     = ["Pikender Sharma"]
  s.email       = ["pikender@vinsol.com"]
  s.homepage    = "http://vinsol.com"
  s.summary     = "Summary of GtpayEngine."
  s.description = "Description of GtpayEngine."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "3.2.16"
  s.add_dependency "gtpay"
  s.add_dependency "httparty"

  s.add_development_dependency "sqlite3"
end
