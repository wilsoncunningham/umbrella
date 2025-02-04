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
  puts "Find passages that mention:"

  client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))
  message_list = [
    {
      "role" => "system",
      "content" => "You are a helpful assistant, specialized in finding Bible passages. You have two possible responses. (1) If you have no Bible passage references that match the question, respond with 'No passages found'. (2) If you do find Bible passages that fit the question, you will respond strictly with a list of the passage references, each separated by a comma with no whitespace. Note that the Bible passages may be as short as one verse and as long as 1 chapter."
    }
  ]

  user_input = gets.chomp
  query = "Find all Bible passages that mention: #{user_input}"

  message_list.append({"role" => "user","content" => query})

  # Call the API to get the next message from GPT
  api_response = client.chat(
    parameters: {
      model: "gpt-4o-mini",
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
  puts "The following passages reference your input:\n"
  passages_list.each do |passage|
    # puts get_esv_text(passage)
    puts passage
  end

  puts "Would you like to read any of these? (yes/no)"
  user_read = gets.chomp

  if user_read.downcase == "yes"
    passages_list.each do |passage|
      puts "-"*60
      puts "Would you like to read #{passage}? (yes/no)"
      puts "-"*60
      user_read_passage = gets.chomp
      puts "\n\n"
      if user_read_passage == "yes"
        puts get_esv_text(passage)
      end
    end
  end
end


##########################################################

# puts get_esv_text(passage)
