Dir[File.dirname(File.dirname(__FILE__)) + "/lib/**/*.rb"].each do |file|
  require file
end
