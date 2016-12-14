#!/usr/bin/env ruby

$:.unshift File.dirname(__FILE__)

require "logger"
require "pathname"
require "yaml"

pr_wk_dir = File.expand_path(File.dirname(__FILE__))
current_path = Pathname.new(pr_wk_dir)
download_dir = current_path.join('Downloads')

# READ Config File
config_file = current_path.join('config', 'printer_destination.yml')
printer_config = YAML.load(File.read(config_file))
list_of_ips = printer_config['printers']

#Dir['Downloads/**/*'].select {|d| File.directory?(d)}.collect {|m| Dir[m + "/*"].first}.compact.inject([]) {|r, o| o.grep(/.*\/(.*)\/(.*)/); r << [$1, $2.split('_').first]}
#Dir['Downloads/**/*'].select {|d| File.directory?(d)}.collect {|m| Dir[m + "/*"].first}.compact.inject({}) {|r, o| o.grep(/.*\/(.*)\/(.*)/); k=$1; v=$2.split('_').first; r[k]=v;r}

ip_make_map = Dir['Downloads/**/*'].select {|d| File.directory?(d)}.collect {|m| Dir[m + "/*"].first}.compact.inject({}) {|r, o| o.grep(/.*\/(.*)\/(.*)/); k=$1; v=$2.split('_').first; r[k]=v;r}

printer_driver_ref = {'C220' => "/Library/Printers/PPDs/Contents/Resources/KONICAMINOLTAC220.gz", 'C224' => "/Library/Printers/PPDs/Contents/Resources/KONICAMINOLTAC224.gz"}

#/usr/sbin/lpadmin -p "10.0.1.101" -E -v lpd://10.0.1.101 -P /Library/Printers/PPDs/Contents/Resources/KONICAMINOLTAC220.gz -D "NYC01"

list_of_ips.each do |l|
  destination_printer_ip = l['ip']

  system_cmd = %Q(/usr/sbin/lpadmin -p "#{destination_printer_ip}" -E -v lpd://#{destination_printer_ip} -P #{printer_driver_ref[ip_make_map[destination_printer_ip]]} -D "#{destination_printer_ip}")
  cmd_response= system(system_cmd)
  p system_cmd
  p cmd_response
end
