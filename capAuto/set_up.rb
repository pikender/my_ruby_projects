#!/usr/bin/env ruby

require 'yaml'
require 'pathname'
require 'fileutils'

# Load Printer Config
# Create Directories under Downloads with IP
# Should we replace DOT with HYPHEN
# Create today and past directories in IP folders

pr_wk_dir = File.expand_path(File.dirname(__FILE__))
current_path = Pathname.new(pr_wk_dir)
download_dir = current_path.join('Downloads')
config_file = current_path.join('config', 'printer_destination.yml')
printer_config = YAML.load(File.read(config_file))
list_of_ips = printer_config['printers']
list_of_ips.each do |l|
  #today_dir = download_dir.join(l['ip'], 'today')
  #past_dir = download_dir.join(l['ip'], 'past')
  #p today_dir, past_dir
  #FileUtils.mkdir_p(today_dir)
  #FileUtils.mkdir_p(past_dir)
  printer_download_dir = download_dir.join(l['ip'])
  FileUtils.mkdir_p(printer_download_dir)
end
