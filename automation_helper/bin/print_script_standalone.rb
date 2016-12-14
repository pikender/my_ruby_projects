#!/usr/bin/env ruby

require "printer_automator_gem"

lg = Wework::LogStep.new

f_todays_date = lg.formatted_today_date 
debug_file_path = lg.debug_log_file.to_s
debug_file = File.open(debug_file_path, 'a')

## Create a Ruby logger
optn = {}
optn[:lgr_inst] = Wework::MultiIO.new(STDOUT, debug_file)
optn[:level] = Logger::DEBUG
optn[:progname] = ENV['PRINTER_URL']

debug_logger = Wework::MyLogger.custom(optn)

debug_logger.info("Open Debug File AT #{debug_file_path}")

Capybara.run_server = false

Capybara.default_driver = :selenium

Capybara.register_driver :selenium do |app|
  profile = Selenium::WebDriver::Chrome::Profile.new
  debug_logger.info("Selenium:: Download::Path: #{ENV['DOWNLOAD_PATH']}")
  profile["download.default_directory"] = ENV['DOWNLOAD_PATH']
  Capybara::Selenium::Driver.new(app, :browser => :chrome, :profile => profile)
end

printer_url = "http://#{ENV['PRINTER_URL']}/wcd"
Capybara.app_host = printer_url

debug_logger.info("Fetch Report from Printer:: #{ENV['PRINTER_URL']}")

spider = Wework::Printer.new(ENV['DOWNLOAD_PATH'], debug_logger)
spider.get_results

debug_logger.info("FINISH Fetch Report from Printer:: #{ENV['PRINTER_URL']}")

debug_logger.info("Close Debug File")
debug_file.close unless debug_file.closed?
