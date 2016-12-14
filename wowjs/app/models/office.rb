class Office < ActiveRecord::Base
  attr_accessible :name, :move_ins_attributes
  has_many :move_ins, :inverse_of => :office
  accepts_nested_attributes_for :move_ins, :allow_destroy => true, :reject_if => Proc.new {|attributes| attributes[:name].blank?}
end
