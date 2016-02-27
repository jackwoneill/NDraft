
class WelcomeController < ApplicationController

  require 'paypal-sdk-rest'
  include PayPal::SDK::REST
  skip_before_filter :authenticate_user!
  
  def index
    if user_signed_in?
      redirect_to contests_path
    end


  PayPal::SDK::REST.set_config(
    :mode => "sandbox", # "sandbox" or "live"
    :client_id => "AUoxo6GUZgd97HRGOeZlskhpURkTgR3VEYcowjTjyxFbPf6BSwIdcQjBe_RkU4b8DtxJxT3B2bFaEp0b",
    :client_secret => "ENMJrALA4a0P9CysZBRiWn-aOkQn0DGw7pJQhYCcLPW9azzmVLF8N1eUsxvHWBBhooPh5KZFk-PnT2Mk")

    # Build Payment object
    api_caller = PayPal::SDK::Permissions::API.new
    request = api_caller.build_request_permissions(
      :scope => ['EXPRESS_CHECKOUT', 'AUTH_CAPTURE', 'REFUND'],
      :callback => 'http://example.com/redirect-to'
    )
    response = api_caller.request_permissions(request)
    # => Request[post]: https://svcs.sandbox.paypal.com/Permissions/RequestPermissions
    # => Response[200]: OK, Duration: 1.296s
    response.token
    @payment = Payment.new({
      :intent => "sale",
      :payer => {
        :payment_method => "credit_card",
        :funding_instruments => [{
          :credit_card => {
            :type => "visa",
            :number => "4567516310777851",
            :expire_month => "11",
            :expire_year => "2018",
            :cvv2 => "874",
            :first_name => "Joe",
            :last_name => "Shopper",
            :billing_address => {
              :line1 => "52 N Main ST",
              :city => "Johnstown",
              :state => "OH",
              :postal_code => "43210",
              :country_code => "US" }}}]},
      :transactions => [{
        :item_list => {
          :items => [{
            :name => "item",
            :sku => "item",
            :price => "1",
            :currency => "USD",
            :quantity => 1 }]},
        :amount => {
          :total => "1.00",
          :currency => "USD" },
        :description => "This is the payment transaction description." }]})

  end
end
