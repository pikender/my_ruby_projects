#!/usr/bin/env ruby

$:.push File.expand_path("../../lib", __FILE__)

require 'try_gem'

p "DOWNLOAD_PATH = #{File.expand_path(ENV['DOWNLOAD_PATH'])}"

raise "No Download Path" if ENV['DOWNLOAD_PATH'].nil?
raise "Not a valid Directory" unless File.directory?(ENV['DOWNLOAD_PATH'])

p 'Start Processing'

TryGem.new(ENV['DOWNLOAD_PATH']).do_it
