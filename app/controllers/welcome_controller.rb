class WelcomeController < ApplicationController  
  skip_before_filter :auth_user, only: [:index, :terms, :account_error]
  skip_before_filter :confirm_balance?, only: [:account_error, :requireInfo]

  def index
    if user_signed_in?
      redirect_to contests_path
    end
  end

  def terms

  end

  def account_error
    @error = params[:error]
  end
  
  def requireInfo
    if current_user.account_verification == 0
      
      
    end
  end

end
