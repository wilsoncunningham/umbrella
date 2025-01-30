require "http"
require "json"
require "dotenv/load"


ESV_API_KEY = ENV.fetch("ESV_API_KEY")
API_URL = "https://api.esv.org/v3/passage/text/"



puts "Please search a bible passage"
passage = gets.chomp
# passage = "Jonah 1-2"


def get_esv_text(passage)
  params = {
      "q": passage,
      "include-headings": true,
      "include-footnotes": false,
      "include-verse-numbers": true,
      "include-short-copyright": true,
      "include-passage-references": false
  }

  headers = {
      "Authorization": "Token #{ESV_API_KEY}"
  }

  response = HTTP.headers(headers).get(API_URL, params: params)
  # puts HTTP.headers(headers)
  # puts response

  body = JSON.parse(response.body.to_s)
  passages = body["passages"]

  passages.any? ? passages[0].strip : "Error: Passage not found"
end

puts get_esv_text(passage)
