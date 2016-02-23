class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  before_filter :confirm_balance?
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:display_name, :email, :password, :password_confirmation) }
  end

  def confirm_balance?
    if user_signed_in?
      if current_user.balance == Balance.where(user_id: current_user.id).take.amount
        return true
      end
      sign_out_and_redirect(current_user)
    end
  end

  def ensure_admin
    redirect_to contests_path if current_user.permissions != 2
  end


  def calcTotalScore(lineup)

    top = Player.find(lineup.top)
    mid = Player.find(lineup.mid)
    adc = Player.find(lineup.adc)
    support = Player.find(lineup.support)
    jungler = Player.find(lineup.jungler)
    flex_1 = Player.find(lineup.flex_1)
    flex_2 = Player.find(lineup.flex_2)
    flex_3 = Player.find(lineup.flex_3)

    total_score = top.live_score + mid.live_score + adc.live_score + support.live_score + jungler.live_score
    total_score = total_score + flex_1.live_score + flex_2.live_score + flex_3.live_score

    lineup.total_score = total_score
    lineup.save
    
  end

  def checkTotalWinnings
    if current_user.total_winnings >= 600
      print("600")
    end
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
