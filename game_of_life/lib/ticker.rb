class Ticker
  attr_accessor :rules

  def initialize
    @rules = []
  end

  def <<(rule)
    unless @rules.include?(rule)
      @rules << rule
    else
      puts "Already present in rule list #{rule.inspect}"  
      "Already present in rule list #{rule.inspect}"
    end
  end

  def remove_rule(rule)
    @rules.delete(rule)
  end

  def tick(grid_pattern, next_gen_grid_pattern)
    ## Modify as dictated by rules
    @rules.each do |rule|
      rule.apply_rule(grid_pattern.cells, next_gen_grid_pattern)
    end    
    next_gen_grid_pattern
  end
end
