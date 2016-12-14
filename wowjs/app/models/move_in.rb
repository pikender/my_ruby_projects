class MoveIn < ActiveRecord::Base
  attr_accessible :name
  belongs_to :office
end
