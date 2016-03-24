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


  def calcTotalScore(lineup)

    player_1 = Player.find(lineup.player_1)
    player_2 = Player.find(lineup.player_2)
    player_3 = Player.find(lineup.player_3)
    player_4 = Player.find(lineup.player_4)
    player_5 = Player.find(lineup.player_5)
    player_6 = Player.find(lineup.player_6)
    player_7 = Player.find(lineup.player_7)
    player_8 = Player.find(lineup.player_8)

    total_score = player_1.live_score + player_2.live_score + player_3.live_score + player_4.live_score + player_5.live_score
    total_score = total_score + player_6.live_score + player_7.live_score + player_8.live_score

    lineup.total_score = total_score
    lineup.save
    
  end

  def checkTotalWinnings
    if current_user.total_winnings >= 600
      print("600")
      #redirect_to give me your ssn path
    end
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
