require 'rubygems'
require 'zip/zip'
require 'find'
require 'fileutils'

# http://dev.mensfeld.pl/2011/12/using-ruby-and-zip-library-to-compress-directories-and-read-single-file-from-compressed-collection/
module Wework
  class Zipper
    # Zipper.zip('/home/user/directory', '/home/user/compressed.zip')
    def self.zip(dir, zip_dir, remove_after = false)
      Zip::ZipFile.open(zip_dir, Zip::ZipFile::CREATE)do |zipfile|
        Find.find(dir) do |path|
          Find.prune if File.basename(path)[0] == ?.
          dest = /#{dir}\/(\w.*)/.match(path)
          # Skip files if they exists
          begin
            zipfile.add(dest[1],path) if dest
          rescue Zip::ZipEntryExistsError
          end
        end
      end
      FileUtils.rm_rf(dir) if remove_after
    end

    # Zipper.unzip('/home/user/compressed.zip','/home/user/directory', true)
    def self.unzip(zip, unzip_dir, remove_after = false)
      Zip::ZipFile.open(zip) do |zip_file|
        zip_file.each do |f|
          f_path=File.join(unzip_dir, f.name)
          FileUtils.mkdir_p(File.dirname(f_path))
          zip_file.extract(f, f_path) unless File.exist?(f_path)
        end
      end
      FileUtils.rm(zip) if remove_after
    end

    # Zipper.open_one('/home/user/source.zip', 'subdir_in_zip/file.ext')
    def self.open_one(zip_source, file_name)
      Zip::ZipFile.open(zip_source) do |zip_file|
        zip_file.each do |f|
          next unless "#{f}" == file_name
          return f.get_input_stream.read
        end
      end
      nil
    end
  end
end
