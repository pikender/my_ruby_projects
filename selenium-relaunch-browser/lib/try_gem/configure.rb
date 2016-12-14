module TryGemConfigure
  @@base_path = File.expand_path("../../../", __FILE__)

  def self.base_path=(base_pth)
    @@base_path = base_pth 
  end

  def self.base_path
    @@base_path
  end

end
