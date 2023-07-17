require 'discordrb'
require 'configatron'
require_relative 'config.rb'

# 
bot = Discordrb::Commands::CommandBot.new token: configatron.token, client_id: configatron.clientid, prefix: '$'

imgs = "https://www.railpictures.net/photo/"

# to generate random number
# img_number = rand 1..836514

bot.message(with_text: "Ping") do |event|
	event.respond("Pong!")
end

bot.run
