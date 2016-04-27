class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  before_filter :confirm_balance?
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:display_name, :email, :password, :password_confirmation, :terms) }
  end

  def confirm_balance?
    if user_signed_in?
      if current_user.balance == Balance.where(user_id: current_user.id).take.amount
        return true
      end
      redirect_to account_error_path(error: "CB1ABIV9")
    end
  end

  def ensure_admin
    redirect_to contests_path if current_user.permissions != 2
  end


 def after_sign_in_path_for(resource)
    sign_in_url = new_user_session_url
    if request.referer == sign_in_url
      super
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end

  def calcTotalScore(lineup)

    players = LineupPlayer.where(lineup_id: lineup.id)

    total_score = 0

    players.each do |p|
      total_score += Player.find(p.player_id).live_score
    end

    lineup.total_score = total_score
    lineup.save
    
  end

  def checkTotalWinnings
    if current_user.total_winnings >= 600
      print("600")
      redirect_to requireInfo_path
    end
  end

  def auth_user
    redirect_to root_path unless user_signed_in?
  end

  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
