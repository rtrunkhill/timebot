require 'discordrb'
# Create a bot
# Here we output the invite URL to the console so the bot account can be invited to the channel. This only has to be


# done once, afterwards, you can remove this part if you want
puts "This timebot's invite URL is #{bot.invite_url}."
puts 'Click on it to invite it to your server.'

# bot.message(start_with: '/timebot help') do |event|
#     event.respond "Enter time to be converted using the 24hr clock, from which timezone, and to which timezone \nTimezones MUST be a numerical value. \n**_Example:_** _2100 +3 -4_\nType 'list' for a list of all timezones\nType 'exit' to close Timebot"
#     time_bot(event)
# end

# bot.message(start_with: '/timebot list') do |event|
#     event.respond "Here is a list of all the timezones: https://en.wikipedia.org/wiki/List_of_time_zone_abbreviations "
#     time_bot(event)
# end

bot.message(start_with: '/timebot') do |event|
    t = Time.now.strftime("%H%M")
    try_this = event.content[9..-1]
    puts "try_this: #{try_this}"
    event.respond "The current time UTC is: __**#{t}**__\nEnter your conversion. **_Example:_** _2100 +3 -4_"
    time_bot(event)
end

# if bot.message(start_with: '/timebot')
#     try_this = bot.message
#     puts "try_this: #{try_this}"
# end


def time_bot(event)
       event.user.await(:conversion) do |convert|
        def letters?(string)
            string.chars.any? { |char| ('a'..'z').include? char.downcase }
        end

        #run time_changer using inputed parameters
        def time_changer(time, zone_a, zone_b)
            message_time = zone_b
            zone_a = zone_a * 100
            zone_b = zone_b * 100
            new_time = time - (zone_a - zone_b)
            if new_time < 0
                final_answer =  "#{2400 - new_time.abs} previous day UTC #{message_time}" 
            elsif new_time > 2400
                final_answer = "#{(2400 - new_time).abs} next day UTC #{message_time}"
            elsif new_time == 2400
                final_answer = "midnight UTC #{message_time}"
            elsif new_time == 0
                final_answer = "midnight previous day UTC #{message_time}"
            elsif new_time < 100
                final_answer  = "00#{new_time} UTC #{message_time}"
            else
                final_answer = "#{new_time } UTC #{message_time}"
            end
            return final_answer
        end
        
        splitting = convert.content.split(' ')
        if splitting[0] == 'exit'
            event.respond "find, i'll go convert time for someone else" 
        elsif splitting[0] == 'list'
            event.respond "Here is a list of all the timezones: https://en.wikipedia.org/wiki/List_of_time_zone_abbreviations."
        elsif splitting[0] == 'help'
            event.respond "Enter time to be converted using the 24hr clock, from which timezone, and to which timezone \nTimezones MUST be a numerical value. \n**_Example:_** _2100 +3 -4_\nType 'list' for a list of all timezones\nType 'exit' to close Timebot"
        elsif splitting.count != 3
            event.respond "You done messed up. It should look like this: _2100 +3 -4_"
        elsif letters?(splitting[1]) == true || letters?(splitting[2]) == true
            event.respond "Timezones must be in numerical format.  It should look like this: _2100 +3 -4_" 
        else
            user_input = splitting.map { |x| x.to_i }
            event.respond time_changer(user_input[0], user_input[1], user_input[2])
        end
    end 
end

bot.run
