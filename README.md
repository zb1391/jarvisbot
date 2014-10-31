# JarvisBot

My Chatbot based on robut

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
