Gem.loaded_specs['gtpay_engine'].dependencies.each do |d|
     require d.name
end

require "gtpay_engine/engine"

module GtpayEngine
end
