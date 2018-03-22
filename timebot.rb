require 'discordrb'
puts "The current UTC time is: #{Time.now}"
# Create a bot
# Here we output the invite URL to the console so the bot account can be invited to the channel. This only has to be


# done once, afterwards, you can remove this part if you want
puts "This timebot's invite URL is #{bot.invite_url}."
puts 'Click on it to invite it to your server.'

bot.message(with_text: '!timebot help') do |event|
    event.respond "Enter time to be converted using the 24hr clock, from which timezone, and to which timezone. Example: 2100, +3, -4"
end

bot.message(with_text: '!timebot list') do |event|
    event.respond "Here is a list of all the timezones: https://en.wikipedia.org/wiki/List_of_time_zone_abbreviations "
end

# need to figure out going backwards over teh date line  eg 1000 +0 -11 currently returns -85am
bot.message(with_text: '!timebot') do |event|
    t = Time.now
    event.respond "The current time UTC is: #{t.strftime("%H%M")}\nEnter your conversion. **_Example:_** _2100 +3 -4_"
    doLoop(event)
end

def doLoop(event)
       event.user.await(:conversion) do |convert|
        if convert.content == 'list'
            event.respond "Here is a list of all the timezones: https://en.wikipedia.org/wiki/List_of_time_zone_abbreviations.  Enter your conversion."
        elsif convert.content == 'help'
            event.respond "Enter time to be converted using the 24hr clock, from which timezone, and to which timezone \nTimezones MUST be a numerical value. \n**_Example:_** _2100 +3 -4_\nlist for a list of all timezones\nexit to close Timebot"
        elsif convert.content == 'exit'
            return event.respond "Fine, I'll go convert for someone else"
            bot.end
            
        else
            splitting = convert.content.split(' ')
            if splitting.count != 3
                event.respond "You done messed up it should look like this: _2100 +3 -4_"
            else
                user_input = splitting.map { |x| x.to_i }
                # puts splitting
            end
        end

        
        #run time_changer using inputed parameters
        def time_changer(time, zone_a, zone_b)
            # return zone_a
            zone_a = zone_a * 100
            zone_b = zone_b * 100
            new_time = time - (zone_a - zone_b)
            if new_time < 0
                final_answer =  "#{2400 - new_time.abs} previous day" 
            elsif new_time > 2400
                final_answer = "#{(2400 - new_time).abs} next day"
            elsif new_time == 2400
                final_answer = "midnight"
            elsif new_time == 0
                final_answer = "midnight previous day"
            elsif new_time < 100
                final_answer  = "00#{new_time}"
            else
                final_answer = "#{new_time}"
            end
            return final_answer
        end
        event.respond time_changer(user_input[0], user_input[1], user_input[2])

    end 
end

bot.run
