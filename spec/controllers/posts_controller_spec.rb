# frozen_string_literal: true

require 'rails_helper'
include JsonWebToken
RSpec.describe PostsController, type: :controller do
  let(:author) { FactoryBot.create(:user, user_type: 'Author') }
  let(:reader) { FactoryBot.create(:user, user_type: 'Reader') }
  let!(:blog) { FactoryBot.create(:blog) }
  let!(:author_post) { FactoryBot.create(:post, user_id: author.id, blog_id: blog.id) }

  before(:each) do
    @author_token = jwt_encode(user_id: author.id)
    @reader_token = jwt_encode(user_id: reader.id)
  end
  let(:authenticate_author) do
    request.headers['Authorization'] = "#{@author_token}"
  end
  let(:authenticate_reader) do
    request.headers['Authorization'] = "#{@reader_token}"
  end
  let(:result) { JSON.parse(response.body) }
  describe 'GET /index' do
    context 'when user_id  present in params so show all post' do
      it 'returns task' do
        authenticate_author
        get :index, params: { user_id: author.id }
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'POST /create' do
    context 'with valid params' do
      it 'returns post' do
        authenticate_author
        post :create, params: { user_id: author.id, title: 'title', body: 'nice post' }
        expect(response.status).to eq(200)
      end
    end
    context 'when current user not present ' do
      it ' task not create' do
        post :create, params: { user_id: author.id }
        expect(response.status).to eq(400)
      end
    end
  end

  describe 'PATCH /update' do
    context 'when author update post' do
      it ' if post updates a successful' do
        authenticate_author
        patch :update, params: { user_id: author.id, id: author_post.id, title: 'updated title' }
        expect(result['title']).to eq('updated title')
        expect(response.status).to eq(200)
      end
    end
    context 'when invalid post id present in params' do
      it 'post not find ' do
        authenticate_author
        patch :update, params: { user_id: author.id, id: 878_677, title: 'update ' }
        expect(result['warning']).to eq("Couldn't find Post with 'id'=878677")
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'GET /show' do
    before do
      authenticate_author
    end
    context 'When valid id present in params' do
      it 'return post' do
        get :show, params: { user_id: author.id, id: 3 }
        expect(response.status).to eq(200)
      end
    end
    context 'When invalid id present in params' do
      it 'post not find' do
        get :show, params: { user_id: author.id, id: 343 }
        expect(result['warning']).to eq("Couldn't find Post with 'id'=343")
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'when valid id presemt in params' do
      it 'return post delete' do
        authenticate_author
        delete :destroy, params: { user_id: author.id, id: author_post.id }
        expect(response.status).to eq(200)
      end
    end
    context 'when invalid id presemt in params' do
      it 'return task not find' do
        authenticate_author
        delete :destroy, params: { user_id: 233, id: 223 }
        expect(result['warning']).to eq("Couldn't find Post with 'id'=223")
        expect(response.status).to eq(200)
      end
    end
  end
end
