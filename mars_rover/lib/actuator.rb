class Actuator
  def operate(machine, commands)
    commands.each_char do |c|
      machine.send_control_command(c)
    end
  end
end
