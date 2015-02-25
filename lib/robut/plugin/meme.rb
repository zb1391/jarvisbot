require 'cgi'

# A simple plugin that wraps memecaptain.
# This plugin is activated when robut is sent a message starting
# with the name of a meme. The list of generators can be discovered
# by running
#
#   @robut meme list
#
# from the command line. Example:
#
#   @robut meme all_the_things write; all the plugins
#
# Send message to the specified meme generator. If the meme requires
# more than one line of text, lines should be separated with a semicolon.
class Robut::Plugin::Meme
  include Robut::Plugin
  
  def check_words(message)
    words(message).count >= 2 && !message.match(/meme (\S+) (.*)$/).nil?
  end
  def handle(time,sender_nick,message)
    if sent_to_me?(message) && check_words(message)
      begin
        # reply ('trying to parse meme data')
        meme_match = message.match(/meme (\S+) (.*)$/).to_s.split(' ')
        meme = meme_match[1]
        if meme.include?("://")
          url = meme_match[1]
        else
          url = "http://memecaptain.com/#{meme}.jpg"
        end
        text = meme_match[2..-1].join(' ')
        line1, line2 = text.split(';').map { |line| CGI.escape(line.strip)}
        meme_url = "http://memecaptain.com/i?u=#{url}&tt=#{line1}"
        meme_url += "&tb=#{line2}" if line2
        reply(meme_url)        
      rescue Exception => ex
        reply("@zacbrown your shitty code doesnt work")
        reply("#{ex.message}")
      end
    end 
  end
end
