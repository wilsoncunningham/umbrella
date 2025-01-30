require "http"
require "json"
require "dotenv/load"
require "openai"


ESV_API_KEY = ENV.fetch("ESV_API_KEY")
API_URL = "https://api.esv.org/v3/passage/text/"



# puts "Please search a bible passage"
# passage = gets.chomp
passage = "Jonah 1-2"


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



########################################

# client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))
# message_list = [
#   {
#     "role" => "system",
#     "content" => "You are a helpful assistant. When asked about Bible passages, you will respond strictly with a list of the passage references,\
#       each separated by a comma with no whitespace. If you have no Bible passage references that match the question, respond with "
#   }
# ]


def ai_search_passage()
  puts "Hello! How can I help you today?"
  puts "-"*50

  client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))
  message_list = [
    {
      "role" => "system",
      "content" => "You are a helpful assistant. When asked about Bible passages, you will respond strictly with a list of the passage references,\
        each separated by a comma with no whitespace. If you have no Bible passage references that match the question, respond with "
    }
  ]

  query = gets.chomp
  # query = "How do I compute 5*5?"

  # Call the API to get the next message from GPT
  api_response = client.chat(
    parameters: {
      model: "gpt-3.5-turbo",
      messages: message_list
    }
  )

  # pp api_response

  ai_message = api_response["choices"][0].fetch("message").fetch("content")
  puts ai_message
  puts "-"*50
end

ai_search_passage()


##########################################################

# puts get_esv_text(passage)
