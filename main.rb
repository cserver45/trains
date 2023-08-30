
=begin
Trains: A discord bot that scrapes the web to find train photos, and give you details about them in you discord server.
Copyright (C) 2023 cserver45

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
=end

require 'discordrb'
require 'httparty'
require 'nokogiri'
require 'configatron'
require_relative 'config.rb'

bot = Discordrb::Commands::CommandBot.new token: configatron.token, client_id: configatron.clientid, intents: :unprivileged

uri = "https://www.railpictures.net/photo/"

# For registering the commands on startup
bot.register_application_command(:train, 'Get a random train photo.')

# To show the licence disclaimer
puts "Copyright (C) 2023 cserver45"
puts "License details are in main.rb and LICENSE"

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

  # why does discordrb make it so hard to make a simple embed?
  # in something like discord.py, its 2 lines to do what ive done here
  # makes no sense to me, but oh well
  builder = Discordrb::Webhooks::Builder.new
  builder.add_embed do |embed|
    embed.description = desc
    embed.color = "#57F287"
    embed.image = Discordrb::Webhooks::EmbedImage.new(url: img)
  end
  
	event.respond(embeds: builder.embeds.map(&:to_hash))
end

bot.run
