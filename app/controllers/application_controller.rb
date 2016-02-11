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
    redirect_to welcome_path if current_user.permissions != 2
  end

  def checkDisplayName
    if user_signed_in?
      if current_user.display_name.nil?
        redirect_to set_display_name_path
      end
    end
  end

  def calcTotalScore(lineup)

    top = Player.find(lineup.top)
    mid = Player.find(lineup.mid)
    adc = Player.find(lineup.adc)
    support = Player.find(lineup.support)
    jungler = Player.find(lineup.jungler)

    lineup.total_score = top.live_score + mid.live_score + adc.live_score + support.live_score + jungler.live_score
    lineup.save
    
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
