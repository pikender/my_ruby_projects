module Visitable
  def accept( visitor, *args )
    visitor.send( "visit_#{self.class.name}".to_sym, self, *args )
  end
end
