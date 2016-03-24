class Contest < ActiveRecord::Base
  has_many :games
  belongs_to :slate
  has_many :lineups

  before_create do 

  end
end
