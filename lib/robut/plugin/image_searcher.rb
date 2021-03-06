# Google's API
require 'google_custom_search_api'

#Used for getting Environment Variables for API KEY
require 'dotenv'
Dotenv.load

class Robut::Plugin::ImageSearcher
  include Robut::Plugin

  GoogleCustomSearchApi::GOOGLE_API_KEY= ENV['CUSTOM_SEARCH_API_KEY']
  GoogleCustomSearchApi::GOOGLE_SEARCH_CX=ENV['CUSTOM_SEARCH_CX']

  def usage
    "#{at_nick} show me <anything> - replies with a google image link"
  end
  
  def check_words(message)
    words(message).count >=2 && words(message).first == "show" && words(message)[1] == "me"
  end
  
  def handle(time,sender_nick,message)
    if sent_to_me?(message) && check_words(message)
      begin
        @results = GoogleCustomSearchApi.search(words(message)[2..-1].join(' '),{searchType: "image", num: 5})
        reply(@results["items"].sample["link"])
      rescue Exception => ex
        if @results["error"] && @results["error"]["code"] == 500
          reply("google can suck my balls. 500 server error")
          reply("http://media.giphy.com/media/13TJrRNMTIn9G8/giphy.gif")
        else
          reply("@zacbrown your shitty code doesnt work")
          reply("#{ex.message}")
        end
      end
    end 
  end
end
