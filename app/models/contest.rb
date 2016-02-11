class Contest < ActiveRecord::Base
  has_many :games

  before_create do 
    self.curr_size = 0
  end
end
