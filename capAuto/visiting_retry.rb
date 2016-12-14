#!/usr/bin/env ruby

$:.unshift File.dirname(__FILE__)

require "logger"
require "pathname"
require "yaml"
require "fileutils"
require "wework_logger"

#module Wework
 # module Kernel
    def system_env(hash, cmd)
      hash.each do |key,val|
        ENV[key] = val
      end
      system cmd
    end
  #end
#end

pr_wk_dir = File.expand_path(File.dirname(__FILE__))
current_path = Pathname.new(pr_wk_dir)
download_dir = current_path.join('Downloads')

# READ Config File
config_file = current_path.join('config', 'printer_destination.yml')
printer_config = YAML.load(File.read(config_file))
list_of_ips = printer_config['printers']

## Open Debug File
todays_date = Date.today
f_todays_date = todays_date.strftime('%Y%m%d')
visiting_retry_file_path = current_path.join('log', "visiting_retry#{f_todays_date}.log").to_s
visiting_retry_file = File.open(visiting_retry_file_path, 'a')
## Create a Ruby logger
visiting_retry_logger = Logger.new(Wework::MultiIO.new(STDOUT, visiting_retry_file))
visiting_retry_logger.level = Logger::DEBUG

visiting_retry_logger.info("Printer Visit log @ #{visiting_retry_file_path}")

printer_script_path = current_path.join('print_script_standalone.rb').to_s
visiting_retry_logger.info("Printer Run Script Path: #{printer_script_path}")


visiting_retry_logger.info("Get IPs missing files: #{printer_script_path}")
csv_print_reports_downloaded = Dir[download_dir.to_s + '/**/*'].grep(/.*_#{f_todays_date}/).select {|x| !File.directory?(x)}


list_of_ips.each do |l|
  if csv_print_reports_downloaded.grep(/#{l['ip']}/).empty?
    destination_printer_ip = l['ip']
    default_directory = download_dir.join(destination_printer_ip) 
    default_directory_path = default_directory.to_s

    visiting_retry_logger.info("Start Processing:: Printer:: IP: #{destination_printer_ip}")
    visiting_retry_logger.info("Printer:: URL: http://#{destination_printer_ip}/wcd")
    visiting_retry_logger.info("Printer:: Password: ********")
    visiting_retry_logger.info("Printer:: Second Password: *********")
    visiting_retry_logger.info("Printer:: Download Path: #{default_directory_path}")
    system_env_hash = {"PRINTER_URL" => destination_printer_ip, "PRINTER_PASSWORD" => (l['sp'] ? ENV['SECOND_PRINTER_PASSWORD'] : ENV['PRIMARY_PRINTER_PASSWORD']), "DOWNLOAD_PATH" => default_directory_path}
    system_cmd = "ruby #{printer_script_path}"
    visiting_retry_logger.info("Printer Script Environment:: #{system_env_hash.inspect}")
    visiting_retry_logger.info("Printer Script Environment:: #{system_cmd}")

    #cmd_response = system(system_env_hash, system_cmd)
    cmd_response = system_env(system_env_hash, system_cmd)
    visiting_retry_logger.info("PRINT SCRIPT RESPONSE:: #{cmd_response}")
  else
    visiting_retry_logger.info("IP: #{l['ip']} must have file already")
  end
end

visiting_retry_logger.info("Close Visting Retry Logger File")
visiting_retry_file.close unless visiting_retry_file.closed?
