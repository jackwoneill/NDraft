class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :display_name, uniqueness: true
  validates :display_name, length: { in: 3..16 }


  validates_format_of :display_name, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true


  around_create :register_hook



# config/routes.rb

end

  private
    def register_hook
      self.permissions = 1
      self.balance = 250.00
      self.total_winnings = 0.00

      yield  # this makes the save happen

        balance = Balance.new(user_id: self.id, amount: 0)

        balance.save
    end