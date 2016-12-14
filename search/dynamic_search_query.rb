module DynamicSearchQuery

  SEARCH_OPERATORS = {:contains => {:name => 'Contains', :op => 'like'},
    :does_not_contain => {:name => 'Does not Contain', :op => 'not like'},
    :starts_with => {:name => 'Starts with', :op => 'like'},
    :ends_with => {:name => 'Ends with', :op => 'like'},
    :equals => {:name => 'Equals', :op => '='},
    :gte => {:name => 'Greater Than Equals', :op => '>='},
    :lte => {:name => 'Less Than Equals', :op => '<='}
  }

  attr_reader :and_conditions

  attr_accessor :values
  attr_accessor :condition
  attr_accessor :errors
  attr_accessor :class_type

  def ui_search_options
    (search_options_hash.map{|k,v| [v[:name],k.to_s]})
  end

  def ui_search_operators
    (SEARCH_OPERATORS.map{|k,v|[v[:name],k.to_s]}).sort
  end

  def set_and_search(opts = {},class_type='SEARCH')

    if(class_type == 'SEARCH') 
      raise "Please Check the Class Name - Comment this Line in Dynamic Search Query if Model Name is Search :)"
    end

    @values = []
    @errors = []
    @condition = ""
    @class_type = class_type
    @and_conditions = opts.blank? ? [] : parse_conditions(opts)
  end

  def search_options
    return self.search_options_hash
  end

  def search_operators
    return SEARCH_OPERATORS
  end


  def valid_q?
    @errors.blank?
  end

  def is_all_blank?
    and_conditions.empty?
  end

  def condition
    and_condition
  end

  def error_messages
    messages = errors.reject{|e|e.class.name == 'BlankSearchFieldException'}.map{|x|x.message}
    messages.push("Illegal blank fields") if has_blank_fields?
    messages.compact.join(",")
  end

  private

  def has_blank_fields?
    errors.any?{|x|x.class.name == 'BlankSearchFieldException'}
  end

  def and_conditions=(val)
    @and_conditions = parse_conditions(val)
  end

  def and_condition
    and_conditions.empty? ? "1=1" : and_conditions.join(' AND ')
  end

  def parse_conditions(conditions)
    valid_conditions = validate_conditions(conditions)
    valid_conditions.map do |param|
      Rails.logger.info "___________________"
      Rails.logger.info param[:search_by]
      parse_predicates(param[:search_by].to_sym,
        param[:search_op].to_sym,
        param[:search_value])
    end
  end

  def validate_conditions(conditions)
    # Check if Hash or Array
    predicates = conditions.respond_to?(:values) ? conditions.values  : conditions
    predicates.select do |param|
      all_not_blank = param.values.all?{|x| !x.blank? }
      all_blank = param.values.all?{|x| x.blank? }
      all_not_blank
    end
  end

  def parse_predicates(field,operator,value)
    search_field = valid_field(field)
    search_operator = valid_operator(field,operator)
    valid_datatype = search_options[field][:datatype]
    parse_value(valid_datatype,operator,value)
    if field == :sub_region and self.class_type=="PriorityTarget"
      "(#{search_field})"
    else
      "#{search_field} #{search_operator} ?"
    end
  end

  def valid_field(field)
    unless search_options.has_key?(field)
      self.errors.push(SearchFieldException.new(:search_field => field))
      return false
    end
    search_options[field][:field]
  end

  def valid_operator(field,operator)
    unless search_options[field][:operators].include?(operator)
      self.errors.push(SearchFieldException.new(:search_op => operator))
      return false
    end
    search_operators[operator][:op]
  end


  def parse_value(valid_datatype,operator, value)
    if valid_datatype == :date
      begin
        self.values << Date.parse(value).to_s
      rescue
        self.errors.push(SearchFieldException.new(:search_value => value))
        return false
      end
    elsif valid_datatype == :like && operator==:equals
      self.values << value.to_s.downcase
    elsif valid_datatype == :like && operator==:starts_with
      self.values << "#{value.to_s.downcase}%"
    elsif valid_datatype == :like && operator==:ends_with
      self.values << "%#{value.to_s.downcase}"
    elsif valid_datatype == :like
      self.values << "%#{value.to_s.downcase}%"
    elsif valid_datatype== :boolean
      self.values << value.to_i
    end
  end

end
