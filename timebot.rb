# require 'discordrb'
puts "the current time is: #{Time.now}"
# Create a bot
timebot = Discordrb::Bot.new token: 'token' #will get a token someplace?

# Here we output the invite URL to the console so the bot account can be invited to the channel. This only has to be
# done once, afterwards, you can remove this part if you want
puts "This timebot's invite URL is #{timebot.invite_url}."
puts 'Click on it to invite it to your server.'


# need to figure out going backwards over teh date line  eg 1000 +0 -11 currently returns -85am
timebot.message(start_with: '!timebot') do |event|
    puts "Here is a list of all the timezones: https://en.wikipedia.org/wiki/List_of_time_zone_abbreviations "
    puts "We use the 24hr clock and timezones are relative to GMT/UTC"
    puts "What time needs to be converted? example: 2100 +5"
    puts "To which timezone? example: -3"
    
    def time_changer(time, zone_a, zone_b)
        zone_a = zone_a * 100
        zone_b = zone_b * 100
        new_time = time + zone_a + zone_b
        return "#{2400 - new_time.abs} hz" if new_time < 0
        return "midnight" if new_time == 2400
        return "#{new_time} hz"
    end

    
    return "That would be --coverted time-- --to.timezone-- GMT + --nextday/previousday--"
end