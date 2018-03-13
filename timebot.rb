# require 'discordrb'
puts "the current time is: #{Time.now}"
# Create a bot
timebot = Discordrb::Bot.new token: 'token' #will get a token someplace?

# Here we output the invite URL to the console so the bot account can be invited to the channel. This only has to be
# done once, afterwards, you can remove this part if you want
puts "This timebot's invite URL is #{timebot.invite_url}."
puts 'Click on it to invite it to your server.'

# bot.message(content: '!time') do |event|
#   # Send a message, and store a reference to it that we can issue a delete request later
#   message = event.respond "The current time is: #{Time.now.strftime('%F %T %Z')}"

#   # React to the message to give a user an easy "button" to press
#   message.react CROSS_MARK

#   # Add an await for a ReactionAddEvent, that will only trigger for reactions
#   # that match our CROSS_MARK emoji. This time, I'm using interpolation to make the
#   # await key unique for this event so that multiple awaits can exist.
#   bot.add_await(:"delete_#{message.id}", Discordrb::Events::ReactionAddEvent, emoji: CROSS_MARK) do |reaction_event|
#     # Since this code will run on every CROSS_MARK reaction, it might not
#     # be on our time message we sent earlier. We use `next` to skip the rest
#     # of the block unless it was our message that was reacted to.
#     next true unless reaction_event.message.id == message.id

#     # Delete the matching message.
#     message.delete
#   end
# end

timebot.message(start_with: '!timebot') do |event|
    puts "Here is a list of all the timezones: https://en.wikipedia.org/wiki/List_of_time_zone_abbreviations "
    puts "We use the 24hr clock and timezones are relative to GMT/UTC"
    puts "What time needs to be converted? example: 2100 +5"
    puts "To which timezone? example: -3"
    
    #do converstion magic here
    
    return "That would be --coverted time-- --to.timezone-- GMT + --nextday/previousday--"
end