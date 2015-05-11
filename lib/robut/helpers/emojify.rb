$:.unshift File.join(File.dirname(__FILE__), ".") # current directory
require 'rest_client'
require 'net/http'
require 'uri'
require 'unirest'
require 'pry'
require 'nokogiri'
require 'open-uri'
require 'magick_cv'
include MagickCv


# Helper module for the HipChat plugin CreateEmoticon
# The goal is to pass a link and a name to the hipchat bot
# and to create an emoticon for the room
module Emojify
  
  # uses magickCV to shrink and save an image link
  # then uploads the image to the chatroom as an emoticon
  def create_emoticon(chatroom_url,email,password,image_link,shortcut,directory_path)
    begin
      cvMat = magickcv_read(image_link)
    rescue
      return "Error: could not read link - make sure you provide a valid entry"
    end
    begin
      smaller_size = create_ratio_cv_size(cvMat)
      smaller = cvMat.resize(smaller_size)
      image_path = "#{directory_path}/#{shortcut}.png"
      smaller.save_image(image_path)
puts 'finished saving image'
    rescue
      return "Error: could not save file - maybe the directory you provided does not exist?"
    end
    upload(chatroom_url,email,password,shortcut,image_path)
  end

  # shrink the cvMat
  # max width is 120
  # shink the smaller (width or height) to maintain a ratio 
  def create_ratio_cv_size(cvMat)
    rows = cvMat.height
    cols = cvMat.width
    if rows > cols
      return CvSize.new((120*cols)/rows,120)
    else
      return CvSize.new(120,(120*rows)/cols)
    end
  end
  
  # Uploads the image to the chatroom
  # chatroom  - uri of chatroom (http://chatroom_name.hipchat.com)
  # email     - email address of admin user
  # password  - password of admin user
  # file_path - path to the image to upload
  def upload(chatroom_url,email,password,shortcut,file_path)
    signin_get = RestClient.get('https://www.hipchat.com/sign_in')
    signin_doc = Nokogiri::HTML(signin_get)
    xsrf_token = signin_doc.css('input[name="xsrf_token"]').first.attributes["value"].value

    signin_response = RestClient.post('https://www.hipchat.com/sign_in', 
	  {email: email, password: password,d: nil,stay_signed_in: 1,signin: "Log+in",xsrf_token: xsrf_token},
    {cookies: signin_get.cookies}){|response, request, result, &block| response}
    
    if signin_response.code != 302
      return "Error - could not sign in: please provide valid credentials"
    end

    # GET emoticons page to store an xsrf_token
    get_request = RestClient.get("#{chatroom_url}/admin/emoticons", {cookies: signin_response.cookies})
    html_doc =  Nokogiri::HTML(get_request)
    xsrf_token = html_doc.css('input[name="xsrf_token"]').first.attributes["value"].value
    

    if get_request.code != 200
      return "Error - could not reach emoticons page. Make sure you provided the right chatroom_url"
    end

    puts 'finished sigining in'

    # POST the progress - expect a 200 code
    progress = RestClient.post("#{chatroom_url}/admin/progress",
						     {shortcut: shortcut, xsrf_token: xsrf_token},
						     {:cookies => signin_response.cookies}){|response, request, result, &block| response}
    if progress.code != 200
      return "Error - something broke when posting to progress - check with someone who knows what they are doing"
    end

    puts " POST Progress: #{progress.code}"
    
    # POST the emoticon - expect a 302 code
    emoticon = RestClient.post("#{chatroom_url}/admin/emoticons",
		{'shortcut' => shortcut,
		'action' => 'add',
		'xsrf_token' => xsrf_token,
		'submit_emoticon' => 'Add emoticon',
		'fileName' => "#{shortcut}.png",
		'Filedata' => File.new(file_path,'rb')},
		{:cookies => signin_response.cookies}){|resp, req, rslt, &blk| resp}
    puts "POST Emoticon: #{emoticon.code}"
    if emoticon.code == 302
      return "You can now use (#{shortcut})"
    elsif emoticon.code == 200
      html_doc =  Nokogiri::HTML(emoticon)
      return html_doc.css('div.aui-message-error p strong').first.text
    else
      return "Error - something broke when posting to emoticons - check with someone who knows what they are doing"
    end
  end
end

