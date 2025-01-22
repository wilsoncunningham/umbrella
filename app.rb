require "http"
require "json"
require "dotenv/load"

PIRATE_WEATHER_KEY = ENV.fetch("PIRATE_WEATHER_KEY")
GOOGLE_MAPS_KEY = ENV.fetch("GOOGLE_MAPS_KEY")
# pp PIRATE_WEATHER_KEY

print "Please enter a location: "
location = gets.chomp
# location = "the wedge beach"
query_location = location.gsub(" ", "%20")

google_maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + query_location + "&key=" + GOOGLE_MAPS_KEY
# pp google_maps_url

google_response_raw = HTTP.get(google_maps_url)
google_response_parsed = JSON.parse(google_response_raw)
# pp google_response_parsed

lat, lng = google_response_parsed.fetch("results")[0].fetch("geometry").fetch("location").fetch("lat"),
            google_response_parsed.fetch("results")[0].fetch("geometry").fetch("location").fetch("lng")
# pp lat
# pp lng


pirate_weather_url = "https://api.pirateweather.net/forecast/" + PIRATE_WEATHER_KEY + "/#{lat},#{lng}"
# pp pirate_weather_url

pirate_response_raw = HTTP.get(pirate_weather_url)
pirate_response_parsed = JSON.parse(pirate_response_raw)
# pp pirate_response_parsed

current_temp = pirate_response_parsed.fetch("currently").fetch("temperature")

puts "The current temperature at '#{location}' is #{current_temp} degrees"


next_hour_data = pirate_response_parsed.fetch("minutely", false)

if next_hour_data
  next_hour_summary = next_hour_data.fetch("summary")

  puts "In the next hour, it will be #{next_hour_summary.downcase}"
end

# next_hour_conditions, next_hour_temp = pirate_response_parsed.fetch("hourly").fetch("data")[0].fetch("summary"),
#                                         pirate_response_parsed.fetch("hourly").fetch("data")[0].fetch("temperature")

# pp "In the next hour, it will be #{next_hour_conditions.downcase} and #{next_hour_temp} degrees"


next_hours = pirate_response_parsed.fetch("hourly").fetch("data")

puts "Conditions for the following 12 hours:"

next_hours[1..12].each_with_index do |hourly_data, idx|
  timestamp = hourly_data["time"]
  time = Time.at(timestamp).utc
  puts "#{time}: #{hourly_data["temperature"]} degrees"

  precip_prob = hourly_data["precipProbability"]
  if precip_prob > 0.1
    print "There is a #{precip_prob} chance of precipitation #{idx + 1} hours from now"
  end
end
