require "http"
require "json"
require "dotenv/load"

PIRATE_WEATHER_KEY = ENV.fetch("PIRATE_WEATHER_KEY")
GOOGLE_MAPS_KEY = ENV.fetch("GOOGLE_MAPS_KEY")
# pp PIRATE_WEATHER_KEY

# location = gets.chomp
location = "the wedge beach"
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

pp "The current temperature at '#{location}' is #{current_temp} degrees"

next_hour_conditions, next_hour_temp = pirate_response_parsed.fetch("hourly").fetch("data")[0].fetch("summary"),
                                        pirate_response_parsed.fetch("hourly").fetch("data")[0].fetch("temperature")

pp "In an hour, it will be #{next_hour_conditions.downcase} and #{next_hour_temp} degrees"


next_hours = pirate_response_parsed.fetch("hourly").fetch("data")


