#!/usr/bin/env ruby

require "rubygems"
require "logger"
require "bundler/setup"
require "capybara"
require "capybara/dsl"
require "selenium/webdriver"
require "pathname"
require "yaml"

pr_wk_dir = File.expand_path(File.dirname(__FILE__))
current_path = Pathname.new(pr_wk_dir)
download_dir = current_path.join('Downloads')

# READ Config File
config_file = current_path.join('config', 'printer_destination.yml')
printer_config = YAML.load(File.read(config_file))
list_of_ips = printer_config['printers']

module Wework
  class MultiIO
    def initialize(*targets)
      @targets = targets
    end

    def write(*args)
      @targets.each {|t| t.write(*args)}
    end

    def close
      @targets.each(&:close)
    end
  end

  class Printer
    include Capybara::DSL
    attr_accessor :download_dir, :log

    def initialize(download_dir, log)
      @download_dir = download_dir
      @log = log
    end

    def get_results
      # Step: Open Admin Login
      log.info('Visit Login Page')
      visit('/login.xml')
      log.info('Fill Password')
      fill_in 'Admin_Pass', :with => ENV['PRINTER_PASSWORD']
      log.info('Click Ok to login')
      click_button('LP1_OK')
      # Step: Handle Post login Success and Failure Cases
      # Failure Scenario 1: Another administrator is currently logged in.
      # Reason 1: Self explanatory
      # Failure Scenario 2: Authentication is invalid or session expired. Please update connection.
      # Reason 2: Session Expired/ Auto Logout after 10 mins
      if page.has_content?('Another administrator is currently logged in.')
        log.fatal('Printer Admin Console is locked by another administrator')
      elsif page.has_content?('Cannot perform service.[Sub Switch is OFF]')
        log.fatal('Cannot perform service.[Sub Switch is OFF]')
      elsif page.has_content?('Authentication is invalid or session expired. Please update connection.')
        log.warn('Printer Admin Console is auto-logged out. Please Try again')
      elsif page.has_content?('Authentication failed.')
        log.warn('Authentication failed')
      elsif page.find(:css, "#ALogout_Button").visible?
        # Should be success case
        log.info('Printer Console is Visible')
        # Step: Click Import/Export (Left Hand menu - Link)
        log.info('Click Import/Export Link on Left Hand Menu')
        click_link('ImpExp')
        # Step: Select Counter (Radio Button)
        log.info('Choose Counter Option')
        choose('R_SEL3')
        # Step: Click Export  (Submit Button)
        log.info('Click Export')
        click_button('ExportButton')
        # Step: Select Account Track Counter
        log.info('Choose Account Track Counter Option')
        choose('Account Track Counter')
        # Step: CLick Ok  (Submit Button)
        log.info('Click Ok within form to get download link')
        within(:css, "div#AS_CNLExport") do
          click_button('Export')
        end
        # Step: Find Download Link and Click
        log.info('Wait for Buttons(Download and Back) to appear')
        sleep(5)
        if page.find(:xpath, "//input[@type='button' and @value='Download']").visible?
          log.info('Download Link is present')
          log.info('Click Download')
          click_button('btnEXE') 
          # Step: Wait for Download to get finished
          log.info('Waiting for Download')
          sleep(30)
          log.info('Finished Waiting for Download')
          # Step: Ensure File is present
          # Else Log Error
          dl_file_glob = download_dir.join('*').to_s
          log.info(dl_file_glob)
          all_file_names = Dir[dl_file_glob]
          search_for_todays_date = Date.today.strftime('%Y%m%d')
          serial_number = 'A0ED013017987'
          todays_files = all_file_names.grep(/.*_#{serial_number}.*_#{search_for_todays_date}/)
          if todays_files.any?
            log.info("Download Successful with file_name:: #{todays_files.first}")
          else
            log.error("Download Failed !!")
          end
          # Step: Move Downloaded file to separate directory to ensure only one download at a time
        end
        # Step: Click Back
        log.info('Click Back')
        click_button('btnOK')
        # Step: Logout Admin
        log.info('Click LogOut')
        click_button('ALogout_Button')
        log.info('Confirm LogOut')
        within(:css, 'div#Logout') do
          click_button('OK')
        end
      else
        log.fatal('A New State Discovered:: Take snapshot and put in proper handling')
      end
      sleep(5)
    rescue => e
      puts "Exception saving screenshot"
      puts e.message
      puts e.backtrace.join("\n")
    ensure
      find_logout_button_if_present = page.find(:css, "#ALogout_Button").visible? rescue nil
      if find_logout_button_if_present
        log.info('Ensure LogOut')
        log.info('Click LogOut')
        click_button('ALogout_Button')
        log.info('Confirm LogOut')
        within(:css, 'div#Logout') do
          click_button('OK')
        end
      end
    end
  end
end

Capybara.run_server = false

Capybara.default_driver = :selenium

## Open Debug File
debug_file = File.open('debug.log', 'a')
## Create a Ruby logger
logger = Logger.new(Wework::MultiIO.new(STDOUT, debug_file))
logger.level = Logger::DEBUG


list_of_ips.each do |l|
  destination_printer_ip = l['ip']
  default_directory = download_dir.join(destination_printer_ip, 'today') 
  default_directory_path = default_directory.to_s

  Capybara.register_driver :selenium do |app|
    profile = Selenium::WebDriver::Chrome::Profile.new
    profile["download.default_directory"] = default_directory_path
    Capybara::Selenium::Driver.new(app, :browser => :chrome, :profile => profile)
  end

  printer_url = "http://#{destination_printer_ip}/wcd"
  Capybara.app_host = printer_url
  logger.info("Printer:: IP: #{destination_printer_ip}")
  logger.info("Printer:: URL: #{printer_url}")
  logger.info("Printer:: Password: #{ENV['PRINTER_PASSWORD']}")
  logger.info("Printer:: Download Path: #{default_directory_path}")

  spider = Wework::Printer.new(default_directory, logger)
  spider.get_results
end

logger.info("Close Debug File")
debug_file.close unless debug_file.closed?
