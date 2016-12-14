class TryCollect
  include Enumerable

  def initialize
    @tries = []
  end

  def add_try(t)
    @tries << t
  end

  def remove_try(ind)
    @tries[ind] = nil
    @tries.compact!
  end

  def each(&block)
    @tries.each(&block)
  end
end
