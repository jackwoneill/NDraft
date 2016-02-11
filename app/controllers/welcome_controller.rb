class WelcomeController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter
  
  def index
    if user_signed_in?
      redirect_to contests_path
    end
  end
end
