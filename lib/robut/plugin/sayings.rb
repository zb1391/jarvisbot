# A simple regex => response plugin.
class Robut::Plugin::Sayings
  include Robut::Plugin

  class << self
    # A list of arrays. The first element is a regex, the second is
    # the reply sent if the regex matches. After the first match, we
    # don't try to match any other sayings. Configuration looks like the following:
    #
    #   [["you're the worst", "I know."], ["sucks", "You know something, you suck!" ]]
    #
    # All regex matches are case-insensitive.
    attr_accessor :sayings
  end
  self.sayings = []

  # Returns a description of how to use this plugin
  def usage
    "#{at_nick} <words> - if <words> matches a regular expression defined in the Chatfile, responds with the specified response"
  end

  # For each element in sayings, creates a regex out of the first
  # element, tries to match +message+ to it, and replies with the
  # second element if it found a match. Robut::Plugin::Sayings will
  # only respond once to each message, with the first match.
  def handle(time, sender_nick, message)
    # Tries to respond to any message sent to robut.
    if sent_to_me?(message)
      self.class.sayings.each do |saying|
        if words(message).join(' ').match(/#{saying.first}/i)
          reply(saying.last)
          return
        end
      end
    end
  end
end
