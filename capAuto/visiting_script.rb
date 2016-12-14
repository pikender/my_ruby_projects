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
visiting_file_path = current_path.join('log', "visiting#{f_todays_date}.log").to_s
visiting_file = File.open(visiting_file_path, 'a')
## Create a Ruby logger
visiting_logger = Logger.new(Wework::MultiIO.new(STDOUT, visiting_file))
visiting_logger.level = Logger::DEBUG

visiting_logger.info("Printer Visit log @ #{visiting_file_path}")

printer_script_path = current_path.join('print_script_standalone.rb').to_s
visiting_logger.info("Printer Run Script Path: #{printer_script_path}")


list_of_ips.each do |l|
  destination_printer_ip = l['ip']
  default_directory = download_dir.join(destination_printer_ip) 
  default_directory_path = default_directory.to_s

  visiting_logger.info("Start Processing:: Printer:: IP: #{destination_printer_ip}")
  visiting_logger.info("Printer:: URL: http://#{destination_printer_ip}/wcd")
  visiting_logger.info("Printer:: Password: ********")
  visiting_logger.info("Printer:: Second Password: *********")
  visiting_logger.info("Printer:: Download Path: #{default_directory_path}")
  system_env_hash = {"PRINTER_URL" => destination_printer_ip, "PRINTER_PASSWORD" => (l['sp'] ? ENV['SECOND_PRINTER_PASSWORD'] : ENV['PRIMARY_PRINTER_PASSWORD']), "DOWNLOAD_PATH" => default_directory_path}
  system_cmd = "ruby #{printer_script_path}"
  visiting_logger.info("Printer Script Environment:: #{system_env_hash.inspect}")
  visiting_logger.info("Printer Script Environment:: #{system_cmd}")

  #cmd_response = system(system_env_hash, system_cmd)
  cmd_response = system_env(system_env_hash, system_cmd)
  visiting_logger.info("PRINT SCRIPT RESPONSE:: #{cmd_response}")
end

visiting_logger.info("Close Visting Logger File")
visiting_file.close unless visiting_file.closed?
