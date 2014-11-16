require 'google/api_client'
CUSTOM_SEARCH_API_KEY="AIzaSyDzSaptBkgMuaryZO7x6Dj2tIT6tWSBhwk"
#CUSTOM_SEARCH_CX="007925812347699012466:2esk7tf5wpu"
client = Google::APIClient.new 
client.authorization = nil
client.key = CUSTOM_SEARCH_API_KEY
puts client.authorization
puts client.key
search = client.discovered_api('customsearch')
starttime = Time.now
puts starttime
response = client.execute(search.cse.list, 'q' => 'poop',authenticated: false)
endtime = Time.now
status,headers,body = response
puts status.results
#puts headers
#puts body
puts "runtime #{endtime-starttime}"

  # Creates an instance of the client.
 # client = Google::APIClient.new
  #client.key = CUSTOM_SEARCH_API_KEY
  #search = client.discovered_api('customsearch')
  
  #response = client.execute(search.cse.list, 'q' => 'poop')
  #status, headers, body = response
  #puts response
