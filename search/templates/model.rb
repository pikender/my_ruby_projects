class <%= class_name %> < <%= parent_class_name.classify %>

  extend DynamicSearchQuery

  def self.find_search_from_query(params)
    search = []
    errors =''
    unless params.blank?
      set_and_search(params,self.to_s)
      if valid_q?
        if !is_all_blank?
          search = all(:conditions => [self.condition,*self.values])
        end
      else
        errors = self.error_messages
      end

    end

    {:search => search,:errors => errors}
  end

  private

  def self.search_options_hash
    search_hash = ActiveSupport::OrderedHash.new
    all_val_cols = default_columns
    col_type_hash = <%= class_name %>.columns_hash
    all_val_cols.each do |column|
      if col_type_hash[column].type == :integer
        search_hash[column.to_sym] = {:name => column.titleize,:field => column,
        :operators => [:equals,:gte,:lte] ,
        :datatype => :like}
      elsif col_type_hash[column].type == :string
        search_hash[column.to_sym] = {:name => column.titleize,:field => "lower(#{column})",
        :operators => [:contains,:does_not_contain,:starts_with,:ends_with,:equals] ,
        :datatype => :like}
      elsif col_type_hash[column].type == :boolean
        search_hash[column.to_sym] = {:name => column.titleize,:field => column,
        :operators => [:equals] ,
        :datatype => :boolean}
      ### To-DO Check Later
      elsif col_type_hash[column].type == :datetime
        search_hash[column.to_sym] = {:name => column.titleize,:field => "to_char(#{column},'yyyy-mm-dd')",
        :operators => [:equals,:gte,:lte],:datatype => :date}
      elsif col_type_hash[column].type == :date
        search_hash[column.to_sym] = {:name => column.titleize,:field => "to_char(#{column},'yyyy-mm-dd')",
        :operators => [:equals,:gte,:lte],:datatype => :date}
      end
    end

    search_hash
  end

  ## Duplicated in Helper
  def self.default_columns
    all_cols = <%= class_name.singularize.camelize %>.column_names.dup
    user_def_cols = all_cols.reject{|c|['created_at','updated_at','id'].include?(c)}
    user_def_cols
  end
end
