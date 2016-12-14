# To change this template, choose Tools | Templates
# and open the template in the editor.

class SearchFieldException < StandardError
  attr_accessor :field, :value, :operator, :data
  def initialize(keys = {})
    @data = "Search Error #OOPS"
    @field = keys[:search_field]
    @value = keys[:search_value]
    @operator = keys[:search_op]
  end

  def message
    if !@field.blank?
      "Unknown search field #{field}"
    elsif !@operator.blank?
      "Unknown search operator #{operator}"
    elsif !@value.blank?
      "Invalid field value #{value}"
    end
  end
end
