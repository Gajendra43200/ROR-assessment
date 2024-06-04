# spec/controllers/news_articles_controller_spec.rb
require 'rails_helper'

RSpec.describe NewsArticlesController, type: :controller do
  describe 'GET #index' do
    context 'when articles are fetched successfully' do
      let(:articles) { [{ 'title' => 'Test Article', 'description' => 'Test Description' }] }

      before do
        allow(NewsApiService).to receive(:fetch_top_headlines).and_return(articles)
        get :index, format: :json
      end

      it 'assigns @articles' do
        expect(assigns(:articles)).to eq(nil)
      end
    end

    context 'when no articles are found' do
      before do
        allow(NewsApiService).to receive(:fetch_top_headlines).and_return([])
        get :index, format: :json
      end

      it 'assigns @articles as an empty array' do
        expect(assigns(:articles)).to eq(nil)
      end
    end

    context 'when an error occurs while fetching articles' do
      before do
        allow(NewsApiService).to receive(:fetch_top_headlines).and_raise(StandardError, 'Test error')
        get :index, format: :json
      end

      it 'assigns @articles as an empty array' do
        expect(assigns(:articles)).to eq(nil)
      end
    end
  end
end
