# Where should we go to lunch today?
class Robut::Plugin::Lunch
  include Robut::Plugin

  # Returns a description of how to use this plugin
  def usage
    [
      "lunch? / food? - #{nick} will suggest a place to go eat",
      "#{at_nick} lunch places - lists all the lunch places #{nick} knows about",
      "#{at_nick} (add|new) lunch place <place> - tells #{nick} about a new place to eat",
      "#{at_nick} remove lunch place <place> - tells #{nick} not to suggest <place> anymore"
    ]
  end

  # Replies with a random string selected from +places+.
  def handle(time, sender_nick, message)
    words = words(message)
    phrase = words.join(' ')
    # lunch?
    if phrase =~ /(lunch|food)\?/i
      if places.empty?
        reply "I don't know about any lunch places"
      else
        reply places[rand(places.length)] + "!"
      end
    # @robut lunch places
    elsif phrase == "lunch places" && sent_to_me?(message)
      if places.empty?
        reply "I don't know about any lunch places"
      else
        reply places.join(', ')
      end
    # @robut new lunch place Green Leaf
    elsif phrase =~ /(?:new|add) lunch place (.*)/i && sent_to_me?(message)
      place = $1
      new_place(place)
      reply "Ok, I'll add \"#{place}\" to the the list of lunch places"
    # @robut remove lunch place Green Leaf
    elsif phrase =~ /remove lunch place (.*)/i && sent_to_me?(message)
      place = $1
      remove_place(place)
      reply "I removed \"#{place}\" from the list of lunch places"
    end
  end

  # Stores +place+ as a new lunch place.
  def new_place(place)
    store["lunch_places"] ||= []
    store["lunch_places"] = (store["lunch_places"] + Array(place)).uniq
  end

  # Removes +place+ from the list of lunch places.
  def remove_place(place)
    store["lunch_places"] ||= []
    store["lunch_places"] = store["lunch_places"] - Array(place)
  end

  # Returns the list of lunch places we know about.
  def places
    store["lunch_places"] ||= []
  end

  # Sets the list of lunch places to +v+
  def places=(v)
    store["lunch_places"] = v
  end

end
