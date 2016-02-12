class Contest < ActiveRecord::Base
  has_many :games

  before_create do 
    self.curr_size = 0
    self.paid_out = false
    self.closed = false
  end
end
