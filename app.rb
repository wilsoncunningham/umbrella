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
pp pirate_weather_url

pirate_response_raw = HTTP.get(pirate_weather_url)
pirate_response_parsed = JSON.parse(pirate_response_raw)
pp pirate_response_parsed

current_temp = pirate_response_parsed.fetch("currently").fetch("temperature")
# pp current_temp

# pp "The current temperature at '#{location}' is #{current_temp} degrees"
