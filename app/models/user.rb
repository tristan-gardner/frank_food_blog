class User < ApplicationRecord
  has_many :recipes
  has_many :reviews
  has_many :votes
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
   validates :username, presence: :true, uniqueness: { case_sensitive: false }
   validate :validate_username
   validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true

   attr_accessor :login

   def login
     @login || self.username || self.email
   end

   def self.find_for_database_authentication(warden_conditions)
     conditions = warden_conditions.dup
     if login = conditions.delete(:login)
       where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
     elsif conditions.has_key?(:username) || conditions.has_key?(:email)
       where(conditions.to_h).first
     end
   end

   def validate_username
     if User.where(email: username).exists?
       errors.add(:username, :invalid)
     end
   end

end
