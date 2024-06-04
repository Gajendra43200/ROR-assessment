require 'open-uri'
class NewsApiService
  API_KEY = '8f375b86cf6d45ca899bc6975d24bd69'
  BASE_URL = 'https://newsapi.org/v2'
  def self.fetch_top_headlines
    url = 'https://newsapi.org/v2/everything?q=bitcoin&apiKey=8f375b86cf6d45ca899bc6975d24bd69'

    response = HTTParty.get(url)
    parsed_response = JSON.parse(response.body)
    Rails.logger.info("API Response: #{parsed_response.inspect}")
    if parsed_response['status'] == 'ok'
      parsed_response['articles'] || []
    else
      []
    end
  rescue StandardError => e
    Rails.logger.error "Error fetching articles: #{e.message}"
    []
  end
end
