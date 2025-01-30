require "http"
require "json"
require "dotenv/load"


ESV_API_KEY = ENV.fetch("ESV_API_KEY")
API_URL = "https://api.esv.org/v3/passage/text/"

passage = "John 3:16"

def get_esv_text(passage)
  params = {
      "q": passage,
      "include-headings": false,
      "include-footnotes": false,
      "include-verse-numbers": false,
      "include-short-copyright": false,
      "include-passage-references": false
  }

  headers = {
      "Authorization": "Token #{ESV_API_KEY}"
  }

  response = HTTP.get(API_URL, params=params, headers=headers)

  passages = response.json()["passages"]

  if passages
    return passages[0].strip()
  else
    "Error: Passage not found"
  end
end

puts get_esv_text(passage)
