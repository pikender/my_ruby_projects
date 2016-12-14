module <%= class_name %>Helper

  def key_columns
    user_def_cols = default_columns
    hash = ActiveSupport::OrderedHash.new
    all_val_cols = user_def_cols
    all_val_cols.each do |column|
      name = column.titleize
      unless column.ends_with?('_id')
        hash[column.to_sym] = {:name  => name, :field => column, :required => is_required(column)}
      else
        field = column[0..column.length-4]
        hash[column.to_sym] = {:name  => name, :field => [field, "#{field}_name"], :required => is_required(column) }
      end
    end

    hash
  end

  def is_required(column)
    #['first_name','last_name', 'email'].include?(column)
    return true
  end

  ## Duplicated in Model
  def default_columns
    all_cols = <%= class_name.singularize.camelize %>.column_names.dup
    user_def_cols = all_cols.reject{|c|['created_at','updated_at','id'].include?(c)}
    user_def_cols
  end

end
