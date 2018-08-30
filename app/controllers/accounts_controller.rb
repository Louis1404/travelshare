class AccountsController < ApplicationController
  skip_after_action :verify_authorized
  def dashboard
    #@trips = current_user.trips
  end
end
