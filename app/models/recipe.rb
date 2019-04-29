class Recipe < ApplicationRecord
  has_many_attached :images
  has_many :reviews
  has_and_belongs_to_many :ingredients
  belongs_to :user
  attr_accessor :ingredient_raw_text
  has_many :up_down_votes
  has_many :users, :through => :up_down_votes

  #scope: :related_recipes, -> { Recipe.most_similar_ingredients(recipe) }

  def upvotes
    self.up_down_votes.where("upvote = ?", true).count
  end

  def downvotes
    self.up_down_votes.where("upvote = ?", false).count
  end

  def hasUpvoter?(user)
    hasUpOrDownvoter?(user, true)
  end

  def hasDownvoter?(user)
    return hasUpOrDownvoter?(user, false)
  end

  def removeVote(upvote)
    downvote = self.up_down_votes.where("user_id = ?", user.id)[0]
    downvote.destroy
  end

  def self.most_similar_ingredients(recipe)
    max_matches = 0
    most_similar = nil
    Recipe.all.each do |r|
      if r.id != recipe.id
        union = (recipe.ingredients + r.ingredients).uniq
        diff = (recipe.ingredients - r.ingredients | r.ingredients - recipe.ingredients)
        intersection = union - diff
        num_matches = intersection.size
        if num_matches > max_matches
          max_matches = num_matches
          most_similar = r
        end
      end
    end
    return most_similar
  end

  private
  def hasUpOrDownvoter?(user, up)
    if self.users.include?(user)
      vote = self.up_down_votes.where("user_id = ?", user.id)[0]
      return vote.upvote == up
    end
  end



  def self.filter_on_constraints(constraint_hash)
    recipes = Recipe.all

    operator_hash = {
        :calories => '<=',
        :cuisine => 'LIKE',
    }
    #byebug
    constraint_hash.each_pair do |key, value|
      symbol = key.to_sym
      operator = operator_hash[symbol]
      if !operator.nil? and value != ""
        recipes = recipes.where("#{symbol.to_s} #{operator} ?", value)
      end
    end
    recipes
  end
end
