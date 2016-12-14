require 'pathname'

module CustomDirPath
  def self.base_path_obj
    Pathname.new(TryGemConfigure.base_path)
  end

  def self.as_download
    self.base_path_obj.join('downloads')
  end
end
