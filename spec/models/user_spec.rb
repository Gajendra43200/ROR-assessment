require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'User' do
    context 'association' do
      it { should have_many(:posts) }
      it { should have_many(:comments) }
      it { should have_many(:blogs) }
      it { should have_many(:likes) }
    end
  end

  context 'validate' do
    it { should validate_presence_of(:email) }
    it { should validate_inclusion_of(:user_type).in_array(%w[Author Reader]) }
  end
end
