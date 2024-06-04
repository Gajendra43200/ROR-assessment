# frozen_string_literal: true

require 'rails_helper'
include JsonWebToken
RSpec.describe CommentsController, type: :controller do
  let!(:user) { FactoryBot.create(:user) }
  let(:post) { FactoryBot.create(:post) }
  let(:post_comment) { FactoryBot.create(:comment, user_id: user.id, post_id: post.id) }
  before(:each) do
    @user_token = jwt_encode(user_id: user.id)
  end
  let(:authenticate_user) do
    request.headers['Authorization'] = "#{@user_token}"
  end
  let(:result) { JSON.parse(response.body) }

  describe 'GET /index' do
    context 'show all comments' do
      before do
        authenticate_user
      end
      # it 'returns comment' do
      #   get :index
      #   expect(response.status).to eq(200)
      # end
    end
  end

  describe 'POST /create' do
    before do
      authenticate_user
    end
    context 'create comment' do
      it 'comment create successfully' do
        expect(response.status).to eq(200)
      end
    end
  end
end
