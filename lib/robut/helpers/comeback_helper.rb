# Helper Module for handling comments with the comeback plugin
module ComebackHelper
  def send_comeback?(sender_nick,message)
    case sender_nick.downcase
    when "zac brown"
    when "justin choi"
      parse_choi_message(message)
    when "michael magaraci"
    when "elijah kim"
    when "michael sohn"
    else
      return false
    end
  end

 
end
