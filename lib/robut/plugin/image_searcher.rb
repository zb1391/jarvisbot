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
        results = GoogleCustomSearchApi.search(words(message)[2..-1].join(' '),{searchType: "image"})
	reply(results["items"].sample["link"])
      rescue
        reply("Why would you search that? What is wrong with you?")
      end
    end 
  end
end

#GoogleCustomSearchApi::GOOGLE_API_KEY='AIzaSyBlWq04THMh66tKAD0bCxWmklPXZQ29C2E'
#GoogleCustomSearchApi::GOOGLE_SEARCH_CX='007925812347699012466:2esk7tf5wpu'


#results = GoogleCustomSearchApi.search("poker",{searchType: "image"})
#puts results
#puts 'printing items'
#puts results["items"]
#puts results["items"].count
#puts results["items"].sample
