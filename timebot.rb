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
bot.message(start_with: '!timebot') do |event|
    t = Time.now
    event.respond "the current time UTC is: #{t.strftime("%H%M")}"

    event.user.await(:conversion) do |convert|
        # if NoMethodError
        #     event.respond "You broke it! Try again?  Type help if you need it" 
        # end
        if convert.content == 'list'
            event.respond "Here is a list of all the timezones: https://en.wikipedia.org/wiki/List_of_time_zone_abbreviations "
        elsif convert.content == 'help'
            event.respond "Enter time to be converted using the 24hr clock, from which timezone, and to which timezone. Example: 2100, +3, -4"
        else
            string = convert.content.split.map { |x| x.to_i }
        end
        

        
        #run time_changer using inputed parameters
        def time_changer(time, zone_a, zone_b)
            zone_a = zone_a * 100t
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
        event.respond time_changer(string[0], string[1], string[2])

    end
    
end

bot.run
