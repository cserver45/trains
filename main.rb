require 'discordrb'
require 'httparty'
require 'nokogiri'
require 'configatron'
require_relative 'config.rb'

bot = Discordrb::Commands::CommandBot.new token: configatron.token, client_id: configatron.clientid

uri = "https://www.railpictures.net/photo/"

# For registering the commands on startup
bot.register_application_command(:train, 'Get a random train photo.')



bot.application_command(:train) do |event|
  img_number = rand 1..836514
  is_img = false
  response = HTTParty.get(uri + img_number.to_s)
  doc = Nokogiri::HTML(response.body)
  while is_img == false do
    begin
      img = doc.at_xpath('//meta[@property ="og:image"]')['content']
      desc = doc.at_xpath('//meta[@name ="description"]')['content']
    rescue NoMethodError
      # need to get a new number, else its an infinite loop
      img_number = rand 1..836514
      response = HTTParty.get(uri + img_number.to_s)
      doc = Nokogiri::HTML(response.body)
	  else
	    is_img = true
	  end
	end
	
	event.respond(content: desc)
	event.send_message(content: img)
end

bot.run
