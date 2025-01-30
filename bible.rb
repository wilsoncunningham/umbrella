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

def ai_search_passages()
  puts "Find a passage that references:"

  client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))
  message_list = [
    {
      "role" => "system",
      "content" => "You are a helpful assistant. When asked about Bible passages, you will respond strictly with a list of the passage references,\
        each separated by a comma with no whitespace. If you have no Bible passage references that match the question, respond with 'No passages found'"
    }
  ]

  user_input = gets.chomp
  query = "Find all Bible passages that reference: #{user_input}"

  message_list.append({"role" => "user","content" => query})

  # Call the API to get the next message from GPT
  api_response = client.chat(
    parameters: {
      model: "gpt-3.5-turbo",
      messages: message_list
    }
  )

  ai_message = api_response["choices"][0].fetch("message").fetch("content")
  return ai_message
end


ai_message = ai_search_passages()
if ai_message != "No passages found"
  passages_list =  ai_message.split(",")
end

if passages_list
  passages_list.each do |passage|
    puts get_esv_text(passage)
  end
end


##########################################################

# puts get_esv_text(passage)
