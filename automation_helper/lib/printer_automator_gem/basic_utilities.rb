#require 'pathname'
#require 'logger'

module Wework
  module BaseMethods
    def formatted_today_date
      Date.today.strftime('%Y%m%d')
    end
  end

  class MyPath
    def self.name
      File.expand_path(File.dirname(__FILE__))
    end 

    def self.as_current
      Pathname.new(MyPath.name)
    end 
  end

  class BasePath
    def self.as_log
      MyPath.as_current.join('log')
    end 
  end

  class LogStep
    include BaseMethods

    def log_file(base_name)
      "#{base_name}#{formatted_today_date}.log"
    end

    def debug_log_file
      log_file('debug')
    end

    def actual_file_path
      BasePath.as_log.join(log_file)
    end
  end

  class MyLogger
    def self.custom(options)
      lgr_inst = options[:lgr_inst] || STDOUT
      lgr = Logger.new(lgr_inst)
      lgr.level = options[:level] || Logger::DEBUG
      lgr.progname = options[:progname] || 'NoProgName'
      lgr.datetime_format = "%Y-%m-%d %H:%M:%S"
      lgr
    end
  end
end
