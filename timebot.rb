require 'discordrb'
puts "the current time is: #{Time.now}"
# Create a bot

# Here we output the invite URL to the console so the bot account can be invited to the channel. This only has to be
# done once, afterwards, you can remove this part if you want
puts "This timebot's invite URL is #{bot.invite_url}."
puts 'Click on it to invite it to your server.'


# need to figure out going backwards over teh date line  eg 1000 +0 -11 currently returns -85am
bot.message(start_with: '!timebot') do |event|
    event.respond "the current time is: #{Time.now}"
    event.respond "Here is a list of all the timezones: https://en.wikipedia.org/wiki/List_of_time_zone_abbreviations "
    event.respond "We use the 24hr clock and timezones are relative to GMT/UTC"
    event.respond "Enter time to be converted, from which timezone, and to which timezone. Example: 2100, +3, -4"
    event.user.await(:conversion) do |convert|
        string = convert.content.split.map { |x| x.to_i }
        # event.respond time_changer(string[0], string[1], string[2])
    #save user input as paramters
    #time needs to be coverted it it leads w/ 00 or 0
        # string = convert.split.map { |x| x.to_i }
        # def make_numbers(convert)
        #     string = convert.split.map { |x| x.to_i }
        #     time_changer(string[0], string[1], string[2])
        # end
        
        #run time_changer using inputed parameters
        def time_changer(time, zone_a, zone_b)
            zone_a = zone_a * 100
            zone_b = zone_b * 100
            new_time = time - (zone_a - zone_b)
            if new_time < 0
                final_answer =  "#{2400 - new_time.abs}hz previous day" 
            elsif new_time > 2400
                final_answer = "#{(2400 - new_time).abs}hz next day"
            elsif new_time == 2400
                final_answer = "midnight"
            elsif new_time == 0
                final_answer = "midnight previous day"
            elsif new_time < 100
                final_answer  = "00#{new_time}hz"
            else
                final_answer = "#{new_time}hz"
            end
            return final_answer
        end
        event.respond time_changer(string[0], string[1], string[2])

    end
    # return time_changer result
    
end

bot.run
