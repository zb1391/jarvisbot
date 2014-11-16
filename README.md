# JarvisBot

My Chatbot based on robut

## No longer is gonna run out of the box :/
I added functionality that depends on ImageMagick and OpenCV. You will have to install both
libraries before you can run bundle install. 

### Creating the .env file
You will also need to create an .env file with a couple things in the root directory
```ruby
CUSTOM_SEARCH_API_KEY="XXXXX" # Create a google search api key
CUSTOM_SEARCH_CX="XXXXX"      # Create a google search engine key
JID='XXXXX'                   # JID of the chatbot
HIP_CHAT_PW='XXXXX'           # Password of chatbot
HIP_CHAT_ROOM='XXXXX'         # Chat room 
EMAIL='XXXXX'                 # Email address of an admin 
EMAIL_PASSWORD='XXXXX'        # Password of an admin
CHATROOM_URL='XXXXX'          # URL of chatroom
EMOTICON_FOLDER='#####'       # Directory where you want to store emoticons
```

## Running
`$ robut /path/to/Chatfile`

## Writing Plugins

Write you plugin in the lib/robut/plugin directory. Here we will a simple hello world plugin

### Usage

`@jarvisbot ping # => "pong"`

### Implementation
lib/robut/plugin/hello_world.rb
``` ruby
class Robut::Plugin::HelloWorld
  include Robut::Plugin

  def handle(time,sender_nick,message)
    if sent_to_me?(message) && words(message).first == "hello"
      reply("Hi there!")
    end 
  end

end
```
### Add to Chatfile
```ruby
# Require plugins here
require 'robut/plugin/hello_world'

# Plugins are handled in the order that they appear in this array.
Robut::Plugin.plugins << Robut::Plugin::HelloWorld

...
