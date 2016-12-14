require "rubygems"
require "bundler/setup"
require "capybara"
require "capybara/dsl"
require "selenium/webdriver"
require "logger"
require "pathname"
require "wework_logger"
require "basic_utilities"

module Wework
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
      elsif page.has_content?('Authentication failed')
        log.warn('Authentication failed')
      elsif page.has_content?('Cannot login while a job is being performed')
        log.warn('Cannot login while a job is being performed.')
      else 
        find_logout_button_if_present = page.find(:css, "#ALogout_Button").visible? rescue nil
        if find_logout_button_if_present
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
            dl_file_glob = download_dir + '/*' # / is present in PATH
            log.info(dl_file_glob)
            all_file_names = Dir[dl_file_glob]
            search_for_todays_date = Date.today.strftime('%Y%m%d')
            todays_files = all_file_names.grep(/.*_#{search_for_todays_date}/)
            log.info("Today Date Formatted: in File: #{search_for_todays_date}")
            log.info("Filenames found:: #{todays_files.inspect}")
            if todays_files.any?
              log.info("Download Successful with file_name:: #{todays_files.first}")
            else
              log.error("Download Failed !!")
            end
            # Step: Move Downloaded file to separate directory to ensure only one download at a time
          else
            log.fatal('Download Link is not visible')
          end
          # Step: Click Back
          log.info('Click Back')
          # Step: Find Back button as some printer define their ID differently
          find_back_button = page.find(:css, "#btnOK") rescue nil
          if find_back_button
            click_button('btnOK')
          else
            log.info('New Back Button clicked')
            click_button('downloadbtnOK')
          end
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
      end
    rescue => e
      log.fatal("Error occured at #{ENV['PRINTER_URL']}")
      log.error("Error Message:: #{e.message}")
      log.error("Error Backtrace #{e.backtrace.join('\n')}")
    rescue Timeout::Error
      log.fatal("Timeout occured at #{ENV['PRINTER_URL']}")
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
