class <%= controller_class_name %>Controller < ApplicationController
  # GET <%= route_url %>
  # GET <%= route_url %>.xml
  def index

    @msg = <%= "params[:msg]" %>
    @failed_contacts = <%= "params[:fail_in_upload]" %>
    @<%= plural_table_name %> = <%= orm_class.all(class_name) %>

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => "" }
    end
  end

  # GET <%= route_url %>/new
  # GET <%= route_url %>/new.xml
  def new
    respond_to do |format|
      format.xls do
        @title = <%= "\"#{plural_table_name}_import_template\"" %>
        @data = <%= "get_common_xls(#{class_name}.key_columns.map{|k,v| v})" %>
        @file_name = <%= "\"#{singular_table_name}.xls\"" %>
        render :template => "/shared/index", :layout => false
      end
    end
  end

  # POST <%= route_url %>
  # POST <%= route_url %>.xml
  def create
    begin
      if <%= "!params[:datafile].blank?" %>
        @<%= "import_#{plural_table_name}" %> = <%= "#{class_name}.read_data(params[:datafile])" %>
        unless @<%= "import_#{plural_table_name}.blank?" %>
          @selected_columns = <%= "#{class_name}.key_columns.map{|k,v| v}" %>
          @num_inserts = @<%= "import_#{plural_table_name}.num_inserts" %>
          @<%= plural_table_name %> = <%= "#{class_name}.all(:limit => @num_inserts,:order => 'id desc')" %>
          if @<%= "import_#{plural_table_name}.failed_instances.blank?" %>
            msg = "List has been imported successfully"
          else
            failed_contacts = @<%= "import_#{plural_table_name}.failed_instances.map{|p| \" \#{p.excel_index}. \#{p.first_name} \#{p.last_name} \"}" %>
            msg = "The following people cannot be uploaded because of missing mandatory fields. Line numbers refer to the order on the Excel spreadsheet."
          end
        else
          msg = "There are no new data to be imported from this file."
        end
      else
        msg = 'Upload a file'
      end
    rescue => e
      msg = e.to_s
    end

    respond_to do |format|
      ## To-Do Need to include message in flash[:error]
      format.html {redirect_to(<%= "#{index_helper}_path(:msg => msg,:fail_in_upload => failed_contacts)" %>)}
    end
  end

  private

  def get_common_xls(header,body_data ='')
    data = {:header => [], :body => [], :footer => []}
    data[:header] = header
    unless body_data.blank?
      data[:body] = body_data.map do|obj|
        h={}
        header.each do|v|
          field = v[:field]
          if field.kind_of?(Array)
            value  = obj.send(field.first).try(:send,field.last)
          else
            value = obj.send(field)
          end
          h = h.merge({v[:field] => value})
        end
        h
      end
    end
    data
  end
end
