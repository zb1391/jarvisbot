require 'calc'

# A simple calculator. This delegates all calculations to the 'calc'
# gem.
class Robut::Plugin::Calc
  include Robut::Plugin

  # Returns a description of how to use this plugin
  def usage
    "#{at_nick} calc <calculation> - replies with the result of <calculation>"
  end
  
  # Perform the calculation specified in +message+, and send the
  # result back.
  def handle(time, sender_nick, message)
    if sent_to_me?(message) && words(message).first == 'calc'
      calculation = words(message, 'calc').join(' ')
      begin
        reply("#{calculation} = #{::Calc.evaluate(calculation)}")
      rescue
        reply("Can't calculate that.")
      end
    end
  end

end
