$:.unshift File.join(File.dirname(__FILE__), "../helpers") # current directory
require 'emojify'
require 'dotenv'
EMAIL = ENV['EMAIL']
PASSWORD = ENV['EMAIL_PASSWORD']
CHATROOM = ENV['CHATROOM_URL']
EMOTICON_DIR = ENV['EMOTICON_FOLDER']

# a plugin to upload emoticons to the chatroom
class Robut::Plugin::EmoticonCreator
  include Robut::Plugin
  include Emojify

  def check_words(message)
    words(message).count >=2 && words(message).first == "emojify"
  end
  
  def handle(time,sender_nick,message)
    if sent_to_me?(message) && check_words(message)
      begin
        if words(message).length != 3
          reply("Wrong Input")
          reply("Emojify: <link> <shortcut>")
        else
          response = create_emoticon(CHATROOM,EMAIL,PASSWORD,words(message)[1],words(message)[2],EMOTICON_DIR)
          reply(response)
        end
      rescue
        reply("Something really bad happened")
      end
    end 
  end

end
