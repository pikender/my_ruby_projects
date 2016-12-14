#!/usr/bin/env ruby

$:.unshift File.dirname(__FILE__)

require "rubygems"
require "bundler/setup"
require "capybara"
require "capybara/dsl"
require "selenium/webdriver"
require "logger"
require "pathname"
require "wework_logger"

pr_wk_dir = File.expand_path(File.dirname(__FILE__))
current_path = Pathname.new(pr_wk_dir)

## Open synchronize File
f_todays_date = Date.today.strftime('%Y%m%d')
synchronize_file_path = current_path.join('log', "synchronize#{f_todays_date}.log").to_s
synchronize_file = File.open(synchronize_file_path, 'a')

## Create a Ruby logger
synchronize_logger = Logger.new(Wework::MultiIO.new(STDOUT, synchronize_file))
synchronize_logger.level = Logger::DEBUG
synchronize_logger.progname = ENV['PRINTER_URL']
synchronize_logger.datetime_format = "%Y-%m-%d %H:%M:%S"
synchronize_logger.info("Open synchronize File AT #{synchronize_file_path}")

Capybara.run_server = false

Capybara.default_driver = :selenium

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

printer_url = "http://#{ENV['PRINTER_URL']}/wcd"
Capybara.app_host = printer_url

module Wework
  class Printer
    include Capybara::DSL
    attr_accessor :log

    def initialize(log)
      @log = log
    end

    def synchronize_datetime
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
          log.info('Click Date/Time Setting Link on Left Hand Menu')
          click_link('DateTime')
          current_time = Time.now
          current_year = current_time.year
          current_month = current_time.month
          current_day = current_time.day
          current_hour = current_time.hour
          current_min = current_time.min
          current_timezone_hours = (current_time.gmt_offset / 3600)
          log.info("Current Timezone hours #{current_timezone_hours}")
          current_timezone_min = "%02d" % ((current_time.gmt_offset % 3600) / 60)
          log.info("Current Timezone Minute #{current_timezone_min}")
          current_timezone_str_text = "#{current_timezone_hours}:#{current_timezone_min}"
          log.info("Current Timezone Text #{current_timezone_str_text}")
          current_timezone_str = ( current_timezone_hours < 0 ? "#{current_timezone_str_text}" : "+#{current_timezone_str_text}" )
          log.info("Current Timezone Actual Select String Value #{current_timezone_str}")
          log.info('Start Setting Time fields')

          old_year_value = find_field('AS_TIM_YEA').value
          log.info("Set Year from #{old_year_value} to #{current_year}")
          fill_in 'AS_TIM_YEA', :with => current_year

          old_month_value = find_field('AS_TIM_MON').value
          log.info("Set Month from #{old_month_value} to #{current_month}")
          fill_in 'AS_TIM_MON', :with => current_month

          old_day_value = find_field('AS_TIM_DAY').value
          log.info("Set Day from #{old_day_value} to #{current_day}")
          fill_in 'AS_TIM_DAY', :with => current_day

          old_hour_value = find_field('AS_TIM_HOU').value
          log.info("Set Hour from #{old_hour_value} to #{current_hour}")
          fill_in 'AS_TIM_HOU', :with => current_hour

          old_min_value = find_field('AS_TIM_MIN').value
          log.info("Set Min from #{old_min_value} to #{current_min}")
          fill_in 'AS_TIM_MIN', :with => current_min

          old_timezone_value = find_field('AS_TIM_ZON').value
          log.info("Select Timezone from #{old_timezone_value} to #{current_timezone_str_text}")
          select current_timezone_str, :from => 'AS_TIM_ZON'

          # Step: CLick Ok  (Submit Button)
          log.info('Click Ok within form to set datetime values')
          within(:css, "div#AS_TIM") do
            click_button('Apply0')
          end
          # Step: Check Completed Text and Click Ok
          if page.has_content?('Completed')
            log.info('Date Time set succesfully')
            log.info('Click Ok')
            # Step: Find Ok button as some printer define their ID differently
            find_ok_button = page.find(:css, "#btnOK") rescue nil
            if find_ok_button
              click_button('btnOK')
            else
              log.info('New OK Button clicked')
              click_button('cgierrorbtnOK')
            end
          else
            log.error('DateTime success not confirmed')
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

synchronize_logger.info("Fetch Report from Printer:: #{ENV['PRINTER_URL']}")

spider = Wework::Printer.new(synchronize_logger)
spider.synchronize_datetime

synchronize_logger.info("FINISH Fetch Report from Printer:: #{ENV['PRINTER_URL']}")

synchronize_logger.info("Close synchronize File")
synchronize_file.close unless synchronize_file.closed?
