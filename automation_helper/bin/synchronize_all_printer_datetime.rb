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

# READ Config File
config_file = current_path.join('config', 'printer_destination.yml')
printer_config = YAML.load(File.read(config_file))
list_of_ips = printer_config['printers']

## Open Debug File
todays_date = Date.today
f_todays_date = todays_date.strftime('%Y%m%d')
sync_visit_file_path = current_path.join('log', "sync_visit#{f_todays_date}.log").to_s
sync_visit_file = File.open(sync_visit_file_path, 'a')
## Create a Ruby logger
sync_visit_logger = Logger.new(Wework::MultiIO.new(STDOUT, sync_visit_file))
sync_visit_logger.level = Logger::DEBUG

sync_visit_logger.info("Printer Visit log @ #{sync_visit_file_path}")

sync_printer_datetime_script_path = current_path.join('synchronize_printer_datetime.rb').to_s
sync_visit_logger.info("Printer Synchronize DateTime Script Path: #{sync_printer_datetime_script_path}")

list_of_ips.each do |l|
  destination_printer_ip = l['ip']

  sync_visit_logger.info("Start Processing:: Printer:: IP: #{destination_printer_ip}")
  sync_visit_logger.info("Printer:: URL: http://#{destination_printer_ip}/wcd")
  sync_visit_logger.info("Printer:: Password: ********")
  sync_visit_logger.info("Printer:: Second Password: *********")
  system_env_hash = {"PRINTER_URL" => destination_printer_ip, "PRINTER_PASSWORD" => (l['sp'] ? ENV['SECOND_PRINTER_PASSWORD'] : ENV['PRIMARY_PRINTER_PASSWORD'])}
  system_cmd = "ruby #{sync_printer_datetime_script_path}"
  sync_visit_logger.info("Printer Script Environment:: #{system_env_hash.inspect}")
  sync_visit_logger.info("Printer Script Environment:: #{system_cmd}")

  #cmd_response = system(system_env_hash, system_cmd)
  cmd_response = system_env(system_env_hash, system_cmd)
  sync_visit_logger.info("PRINT SCRIPT RESPONSE:: #{cmd_response}")
end

sync_visit_logger.info("Close Visting Logger File")
sync_visit_file.close unless sync_visit_file.closed?
