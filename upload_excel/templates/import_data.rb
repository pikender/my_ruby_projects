#attr_accessor :datafile
#attr_accessor :class_type

class ImportData
  def initialize(class_type,options={})
    @datafile = options[:datafile]
    @class_type = class_type
  end

  def self.factory(class_type,datafile)
    "#{class_type.to_s}Import".constantize.new(class_type,{:datafile => datafile})
  end

  def parse_contacts(datafile, class_name)
    contacts =[]
    begin
      file_type = datafile.original_filename.scan(/\.\w+$/).first
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
        contacts = "#{class_name}".constantize.import(columns, array)
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

  def valid?(headers)
    !(headers.blank? && !headers.kind_of?(Array) and  headers.any?{|h|h.nil?})
  end
  
end
