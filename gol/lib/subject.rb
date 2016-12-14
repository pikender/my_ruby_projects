module Subject
  attr_reader :observers

  def initialize
    @observers = Array.new
  end

  def add_observer(observer)
    @observers << observer
  end

  def delete_observer(observer)
    @observers.delete(observer)
  end

  def notify_observers
    @observers.each do |ob|
#      Pass self so that observer can access easily all the information
      ob.update(self)
    end  
  end
end
