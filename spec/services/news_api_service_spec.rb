require 'rails_helper'

RSpec.describe NewsApiService, type: :service do
  describe '.fetch_top_headlines' do
    let(:api_key) { '8f375b86cf6d45ca899bc6975d24bd69' }
    let(:url) { 'https://newsapi.org/v2/everything?q=bitcoin&apiKey=8f375b86cf6d45ca899bc6975d24bd69' }

    context 'when the API returns articles' do
      let(:response_body) do
        {
          status: 'ok',
          articles: [
            { 'title' => 'Article 1', 'description' => 'Description 1' },
            { 'title' => 'Article 2', 'description' => 'Description 2' }
          ]
        }.to_json
      end

      before do
        stub_request(:get, url)
          .to_return(status: 200, body: response_body, headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns a list of articles' do
        articles = NewsApiService.fetch_top_headlines
        expect(articles).to be_an(Array)
        expect(articles.size).to eq(2)
        expect(articles.first['title']).to eq('Article 1')
      end
    end

    context 'when the API returns an error' do
      let(:response_body) do
        { status: 'error', message: 'API key is invalid.' }.to_json
      end

      before do
        stub_request(:get, url)
          .to_return(status: 401, body: response_body, headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns an empty array' do
        articles = NewsApiService.fetch_top_headlines
        expect(articles).to eq([])
      end
    end

    context 'when an exception occurs' do
      before do
        allow(HTTParty).to receive(:get).and_raise(StandardError.new('Some error'))
      end

      it 'returns an empty array' do
        articles = NewsApiService.fetch_top_headlines
        expect(articles).to eq([])
      end
    end
  end
end
