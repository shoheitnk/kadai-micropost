class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, 
                    uniqueness: { case_sensitive: false }
  has_secure_password

  # 投稿機能
  has_many :microposts
  
  # follow 機能
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  # favourite 機能
  has_many :favourites
  has_many :favouriteposts, through: :favourites, source: :micropost
  
  # follow 機能
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end

  # favourite 機能
  def favourite(micropost)
    Favourite.find_or_create_by(uesr_id: self.id, micropost_id: micropost.id)
  end
  
  def unfavourite(micropost)
    favourite = self.favourites.find_by(micropost_id: micropost.id)
    favourite.destroy if favourite
  end
  
  def favourite?(micropost)
    self.favouriteposts.include?(micropost)
  end
  
  # timeline 機能
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
end

