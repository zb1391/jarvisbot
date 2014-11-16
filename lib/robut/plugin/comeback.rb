$:.unshift File.join(File.dirname(__FILE__), "../helpers") # current directory
require 'twss'
require 'comeback_helper'

# A simple plugin that feeds everything said in the room through the
# twss gem. Requires the 'twss' gem, obviously.
class Robut::Plugin::Comeback
  include Robut::Plugin

  # Responds with a comeback depending on the sender
  def handle(time,sender_nick, message)
    # Figure out who is the sender
    # send a response based on the sender and the message
    puts sender_nick
    process_response(sender_nick, message)
  end

  private
  def process_response(sender_nick, message)
    ComebackHelper::send_comeback?(sender_nick,message)
    #reply(ComebackHelper::get_comeback(sender_nick,message) if ComebackHelper::send_comeback?(sender_nick, message)  
  end

end
