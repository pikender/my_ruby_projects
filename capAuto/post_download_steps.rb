#!/usr/bin/env ruby

$:.unshift File.dirname(__FILE__)

require "logger"
require "pathname"
require "yaml"
require "fileutils"
require "wework_logger"
require "zip_utility"
require "en_email_utility"

pr_wk_dir = File.expand_path(File.dirname(__FILE__))
current_path = Pathname.new(pr_wk_dir)
download_dir = current_path.join('Downloads')

# READ Config File
config_file = current_path.join('config', 'printer_destination.yml')
printer_config = YAML.load_file(config_file)
list_of_ips = printer_config['printers']

## Open Debug File
todays_date = Date.today
f_todays_date = todays_date.strftime('%Y%m%d')
log_path_obj = current_path.join('log')
post_ppi_file_path = current_path.join('log', "post_pp#{f_todays_date}.log").to_s
post_ppi_file = File.open(post_ppi_file_path, 'a')
## Create a Ruby logger
post_ppi_logger = Logger.new(Wework::MultiIO.new(STDOUT, post_ppi_file))
post_ppi_logger.level = Logger::DEBUG

# Do Post Download Steps
# Move Downloaded reports to their respective past folder
# Dir[File.expand_path(File.dirname(__FILE__)) + '/Downloads/**/*'].select {|x| !File.directory?(x)}.each {|y| FileUtils.cp(y, '/Users/printer/reports')}
# Move Downloaded reports to the respective date folder in User/printer/reports
# Create Report for Downloaded and Left Printer CSV files
# Curl and send reports to  WeConnect to populate print usage
# TODO: Convert to Class and Use its object
begin
  # Copy to reports folder
  post_ppi_logger.info('Copy Reports to User Reports folder with todays date')
  home_dir_path = Pathname.new(File.expand_path('~'))
  reports_path_obj = home_dir_path.join('reports', f_todays_date)
  reports_path = reports_path_obj.to_s
  post_ppi_logger.info("Create User Reports folder :: #{reports_path}")
  FileUtils.mkdir_p(reports_path)
  post_ppi_logger.info("Copy Reports to User Reports folder :: #{reports_path}")
  csv_print_reports_downloaded = Dir[download_dir.to_s + '/**/*'].grep(/.*_#{f_todays_date}/).select {|x| !File.directory?(x)}
  post_ppi_logger.info("Printer Reports Downloaded Path:: #{csv_print_reports_downloaded.join(', ')}")
  post_ppi_logger.info("Copy Reports to User Reports folder in their respective IP series")
  csv_print_reports_downloaded.each do |y|
    dir_file_path = File.dirname(y)
    get_ip_folder = File.basename(dir_file_path)
    split_on_dot = get_ip_folder.split('.')
    first_two_dgts = split_on_dot.slice(0, 2)
    first_two_dgts << 'x'
    first_two_dgts << 'x'
    ip_x_dir = first_two_dgts.join('.')
    new_rep_path = reports_path_obj.join(ip_x_dir).to_s
    post_ppi_logger.info("FileName: #{y}, New Report Path: #{new_rep_path}")
    FileUtils.mkdir_p(new_rep_path)
    FileUtils.cp(y, new_rep_path)
  end
  # Missing File Report
  missing_files_from_ips = list_of_ips.collect {|l| if csv_print_reports_downloaded.grep(/#{l['ip']}/).empty? then l['ip'] else nil end}.compact
  missing_files_formatted = "Missing Printer IPs reports:: #{missing_files_from_ips.join(', ')}"
  post_ppi_logger.error(missing_files_formatted)
  if csv_print_reports_downloaded.any?
    # Generate Failure Report
    debug_log_report_path = log_path_obj.join("debug#{f_todays_date}.log").to_s
    failure_report_abs_path = log_path_obj.join("failure_report#{f_todays_date}.log").to_s
    post_ppi_logger.info("Debug Report File Path: #{debug_log_report_path}")
    post_ppi_logger.info("Failure Report File Path: #{failure_report_abs_path}")
    cmd_to_grep_fatal_warn_erros = "cat #{debug_log_report_path} | egrep -in 'fatal|error|warn' > #{failure_report_abs_path}"
    post_ppi_logger.info("Command to Run Report File: #{cmd_to_grep_fatal_warn_erros}")
    if system(cmd_to_grep_fatal_warn_erros)
      post_ppi_logger.info("Command to Run Report File:: Success:: File Exists #{File.exists?(failure_report_abs_path)}")
    else
      post_ppi_logger.fatal("Command to Run Report File:: Failure:: Body")
    end
    # Copy Log files too
    glob_log_path = log_path_obj.join('*')
    log_files = Dir[glob_log_path.to_s].grep(/.*#{f_todays_date}/).select {|x| !File.directory?(x)}
    post_ppi_logger.info("Log Files Path: #{log_files.join(', ')}")
    rep_log_path = reports_path_obj.join('log').to_s
    # Create Log folder in reports folder
    post_ppi_logger.info("Report Log Path: #{rep_log_path}")
    FileUtils.mkdir_p(rep_log_path)
    log_files.each do |l|
      post_ppi_logger.info("Report Log File: #{l}")
      FileUtils.cp(l, rep_log_path)
    end
    # Zip Reports Folder Contents
    post_ppi_logger.info('Zip Report Contents to attach in mail')
    Wework::Zipper.zip(reports_path, "#{reports_path}.zip")
    # Send Mail
    post_ppi_logger.info('Send zipped Report Contents in mail')
    mailer = Wework::SMTPGoogleMailer.new
    smtp_info = YAML.load_file(current_path.join('smtp_info.yml').to_s)
    mailer.smtp_info = smtp_info
    from = smtp_info[:username]
    to = smtp_info[:username]
    subject = "Printer Report for Date: #{todays_date}"
    attachment = "#{reports_path}.zip"
    body = "List of Printer IPs whose reports are missing #{missing_files_from_ips.join(', ')}"
    begin
      body_a = ["Failure Report"]
      body_a << File.read(failure_report_abs_path) 
      body = body_a.join("\n")
      post_ppi_logger.info("Failure Report File Read:: Success:: Body #{body}")
    rescue => e
      post_ppi_logger.fatal("Failure Report Path unable to read:: #{body}")
    end
    mailer.send_attachment_email from, to, subject, body, attachment
    # Upload on WeConnect
    if ENV['PRINTER_AUTH_TOKEN_KEY'].nil? || ENV['PRINTER_AUTH_TOKEN_VALUE'].nil? || ENV['PRINTER_UPLOAD_API_ENDPOINT'].nil? || ENV['PRINTER_AUTH_TOKEN_KEY'].empty? || ENV['PRINTER_AUTH_TOKEN_VALUE'].empty? || ENV['PRINTER_UPLOAD_API_ENDPOINT'].empty?
      post_ppi_logger.info('You have to send data to WeConnect manually now')
    else
      todays_file_downloaded = Dir[reports_path + '/**/*'].grep(/.*_#{f_todays_date}/).select {|x| !File.directory?(x)}
      post_ppi_logger.info("Show User Reports folder Contents:: #{todays_file_downloaded}")
      create_curl_command = ['curl -H']
      create_curl_command << %Q("#{ENV['PRINTER_AUTH_TOKEN_KEY']}: #{ENV['PRINTER_AUTH_TOKEN_VALUE']}")
      join_file_names = todays_file_downloaded.collect {|t| %Q(-F "files[]=@#{t}")}
      if join_file_names.any?
        create_curl_command << join_file_names.flatten
        create_curl_command << [ENV['PRINTER_UPLOAD_API_ENDPOINT']]
        final_curl_command = create_curl_command.join(' ')
        curl_response = system(final_curl_command)
        post_ppi_logger.info("Curl Response to #{final_curl_command} #{curl_response}")
      else
        post_ppi_logger.fatal('No Files downloaded for any printer')
      end
    end
  else
    post_ppi_logger.fatal('Check the Cron or trigger manually')
  end
rescue => e
  post_ppi_logger.error("Reports Processing:: Error Message:: #{e.message}")
  post_ppi_logger.error("Reports Processing:: Error Backtrace #{e.backtrace.join('\n')}")
end

post_ppi_logger.info("Close Post Download Logger File")
post_ppi_file.close unless post_ppi_file.closed?
