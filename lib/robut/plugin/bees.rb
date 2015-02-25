class Robut::Plugin::Bees
  include Robut::Plugin

  def bees
    ["http://i.minus.com/i6reaKbR9zMAK.gif",
     "http://www.reactiongifs.us/wp-content/uploads/2013/04/bees_oprah.gif",
     "http://media.giphy.com/media/ktZJlSaABbSOk/giphy.gif",
     "http://cdn.doandroidsdance.com/assets/2013/05/skrillex-bee.gif",
     "http://emmyc.com/BEES.gif",
     "http://stream1.gifsoup.com/view2/1891364/i-hate-you-bees-o.gif"].sample
  end
  
  def check_words(message)
    # regex for bee(s) or bead(s)
    !(message =~ /(bee|bead+?)(s\b|\b)/).nil?
  end
  
  def handle(time,sender_nick,message)
    if sent_to_me?(message) && check_words(message)
      begin
        reply(bees)
      rescue Exception => ex
        reply("@zacbrown your shitty code doesnt work")
        reply("#{ex.message}")
      end
    end 
  end
end
