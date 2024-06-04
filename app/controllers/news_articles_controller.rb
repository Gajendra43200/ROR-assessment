class NewsArticlesController < ApiController
  def index
    @articles = NewsApiService.fetch_top_headlines
    render json: { message: 'No articles found.' } if @articles.empty?
  rescue StandardError => e
    Rails.logger.error "Failed to fetch articles: #{e.message}"
    render json: { message: 'An error occurred while fetching articles. Please try again later.' }
    @articles = []
  end
end
