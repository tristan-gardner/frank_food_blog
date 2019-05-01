require 'rails_helper'

RSpec.describe UpDownVote, type: :model do
  before(:each) do
    @user = User.create!(username: "a", email: "a@a.com", password: "password")
    @recipe = Recipe.create!(name: "recipe")
  end
  describe "object creation" do
    it "should be able to create an UpDownVote object with all the right properties" do
      vote = UpDownVote.new(upvote: true, user: @user, recipe: @recipe)
      expect(vote).to respond_to(:upvote)
      expect(vote).to respond_to(:user)
      expect(vote).to respond_to(:user)
    end
    it "should fail when up or down is not indicated" do
      expect { vote = UpDownVote.create!(user: @user, recipe: @recipe) }.to raise_error(ActiveRecord::RecordInvalid)
    end



  end
end
