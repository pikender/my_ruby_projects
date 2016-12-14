class <%= class_name %> < <%= parent_class_name.classify %>
  def self.read_data(datafile)
    begin
      contacts = parse_contacts(datafile)
      contacts
    rescue Exception => e
      raise e
    end
  end

  def self.get_data(headers,row)
    data =[]
    headers.each_with_index do |h,i|
      source = key_columns.map{|k,v|v[:name]}
      if source.include?(h)
        if is_boolean?(h)
          data <<  get_boolean_value(row[i])
        else
         row[i] =  row[i].class.to_s=='Float'? row[i].to_i.to_s : row[i]
         data << row[i]
        end
      end
    end
    data
  end

  def self.get_columns(headers)
    arr = []
    columns = headers.map do|h|
      key_columns.each do |k,v|
        if h == v[:name]
          arr = k and break
        else
          arr = nil
        end
      end
      arr
    end
    columns = columns.reject{|c|c==nil}
  end

  ## can be customized to check Boolean Values
  def self.is_boolean?(h)
    ['Is Priority Target'].include?(h)
  end

  def self.get_boolean_value(value)
    if value=='true' || value=='Y' || value=='yes'
      return 1
    elsif value=='false'|| value=='N' || value=='no'
      return 0
    end
  end

  ## To-Do Need to re-factor to move to helpers
  def self.key_columns
    column_names.reject!{|c| ['created_at','updated_at','id'].include?(c)}
    hash = ActiveSupport::OrderedHash.new
    column_names.each do |column|
      name = column.titleize
      unless column.ends_with?('_id')
        hash[column.to_sym] = {:name  => name, :field => column, :required => true}
      else
        field = column[0..column.length-4]
        hash[column.to_sym] = {:name  => name, :field => [field, "#{field}_name"], :required => true }
      end
    end

    hash
  end

  def self.parse_contacts(datafile)
    contacts =[]
    begin
      file_type = datafile.original_filename.scan(/\.\w+$/).first
#      Note in Rails 3, you get file ref from param.tempfile and not simple param
      if file_type=='.csv'
        data_rows = FasterCSV.parse(datafile.tempfile)
        data_rows = data_rows.to_a
        headers = data_rows.first
      elsif file_type=='.xls'
        book = Spreadsheet.open(datafile.tempfile)
        data_rows = book.worksheet 0
        headers = data_rows.row(0)
      end
      headers = headers.map{|h|h.strip}

      is_valid = valid?(headers)
      columns = get_columns(headers).concat(['created_at','updated_at'])
      raise if !is_valid || data_rows.blank? || columns.blank?
      if is_valid || !data_rows.blank?
        array =[]
        data_rows.each_with_index do|row, i|
          array << get_data(headers,row) if i!=0
        end
        raise if array.blank?
        array.each{|a|a.concat([Time.zone.parse(Date.today.to_s),Time.zone.parse(Date.today.to_s)])}
        contacts = import(columns, array)
      end
    rescue Exception => e
      if !is_valid || data_rows.blank? || array.blank?
        err_mesg = ((!is_valid ? ("Not Valid") : (data_rows.blank? ? ("No Data to Upload") : (array.blank? ? ("Data Not Parsed Properly") : ("")))))
        raise "This file cannot be uploaded. Some required fields are missing. #{err_mesg} "
      else
        raise "The file is ill-formatted. Please upload another one."
      end
    end
    return contacts
  end

  def self.valid?(headers)
    !(headers.blank? && !headers.kind_of?(Array) and  headers.any?{|h|h.nil?})
  end

end
