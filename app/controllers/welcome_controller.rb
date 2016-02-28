
class WelcomeController < ApplicationController  
  def index
    if user_signed_in?
      redirect_to contests_path
    end


  # PayPal::SDK::REST.set_config(
  #   :mode => "sandbox", # "sandbox" or "live"
  #   :client_id => "AUoxo6GUZgd97HRGOeZlskhpURkTgR3VEYcowjTjyxFbPf6BSwIdcQjBe_RkU4b8DtxJxT3B2bFaEp0b",
  #   :client_secret => "ENMJrALA4a0P9CysZBRiWn-aOkQn0DGw7pJQhYCcLPW9azzmVLF8N1eUsxvHWBBhooPh5KZFk-PnT2Mk")

  #   # Build Payment object
  #   api_caller = PayPal::SDK::Permissions::API.new
  #   request = api_caller.build_request_permissions(
  #     :scope => ['EXPRESS_CHECKOUT', 'AUTH_CAPTURE', 'REFUND'],
  #     :callback => 'http://example.com/redirect-to'
  #   )
  #   response = api_caller.request_permissions(request)
  #   # => Request[post]: https://svcs.sandbox.paypal.com/Permissions/RequestPermissions
  #   # => Response[200]: OK, Duration: 1.296s
  #   response.token


  end
end
