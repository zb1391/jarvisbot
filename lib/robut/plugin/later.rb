# The Later plugin allows you to send messages/commands to robut based on
# a time delay.  Like so:
#
#    @robut in 5 minutes lunch?
#    @robut in 1 hr echo @justin wake up!
#
# @robut will respond effectively the same as he would if someone had told
# him "lunch?" 5 minutes from now.  In the case of the Lunch plugin, he
# would repond with a lunch suggestion.  The Later plugin works with all other
# plugins as you follow this syntax:
#
#    @robut in <number> <mins|hrs|secs> [command]
#
# Where command is the message you want to send to @robut in the future.  For
# the time denominations it also recognizes minute, minutes, hour, hours,
# second, seconds.
#
class Robut::Plugin::Later
  include Robut::Plugin

  # Returns a description of how to use this plugin
  def usage
    "#{at_nick} in <number> <mins|hrs|secs> <command> - sends <command> to #{nick} after the specified interval"
  end
  
  # Passes +message+ back through the plugin chain if we've been given
  # a time to execute it later.
  def handle(time, sender_nick, message)
    if sent_to_me?(message)
      phrase = words(message).join(' ')
      if phrase =~ timer_regex
        count = $1.to_i
        scale = $2
        future_message =  at_nick + ' ' + $3

        sleep_time = count * scale_multiplier(scale)

        reply("Ok, see you in #{count} #{scale}")

        connection = self.connection
        threader do
          sleep sleep_time
          fake_message(Time.now, sender_nick, future_message)
        end
        return true
      end
    end
  end

  private

  # A regex that detects a time.
  def timer_regex
    /in (.*) (sec|secs|second|seconds|min|mins|minute|minutes|hr|hrs|hour|hours) (.*)$/
  end

  # Takes a time scale (secs, mins, hours, etc.) and returns the
  # factor to convert it into seconds.
  def scale_multiplier(time_scale)
    case time_scale
    when /sec(s|ond|onds)?/
      1
    when /min(s|ute|utes)?/
      60
    when /(hr|hrs|hour|hours)/
      60 * 60
    end
  end

  # Asynchronously runs the given block.
  def threader
    Thread.new do
      yield
    end
  end

end
