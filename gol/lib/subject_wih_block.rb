##Sample Call ::
##subject.add_observer do |observer|
##  puts "Defined Code Block #{observer.inspect} ; Called with #call"  
##end

module SubjectWithBlock
  def initialize
    @observers = Array.new
  end

  def add_observer(&observer)
    @observers << observer
  end

# TODO Need to see the usage
  def delete_observer(observer)
    @observers.delete(observer)
  end

  def notify_observers
    @observers.each do |ob|
#      Pass self so that observer can access easily all the information
      ob.call(self)
    end  
  end
end
