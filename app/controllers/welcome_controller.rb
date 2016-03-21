
class WelcomeController < ApplicationController  
  def index
    if user_signed_in?
      redirect_to contests_path
    end

  end
end
