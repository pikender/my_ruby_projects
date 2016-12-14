require 'uri' # Uri Library
require 'net/http' # Net Library
require 'json' # to_json method

module Sendgrid
end

Dir[File.dirname(__FILE__) + '/sendgrid/*.rb'].each do |file|
  require file
end 

