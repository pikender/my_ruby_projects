class CompositeCommand < Command
  attr_reader :commands

  def initialize
    @commands = []
  end

  def add_command(cmd)
    @commands << cmd
  end

  def delete_command(cmd)
    @commands.delete(cmd)
  end

  def execute
    @commands.each {|cmd| cmd.execute}
  end

  def description
    description = ''
    @commands.each {|cmd| description += "#{cmd.cell.to_debug} #{cmd.description}\n"}
    description
  end
end
