class Command
  attr_reader :description

  def initialize(description)
    @description = description
  end

  def execute
    raise "NotImplemented :: Call Actual Command's execute"
  end
end

