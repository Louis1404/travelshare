class ProfilesController < ApplicationController

  def show
    authorize @profile
  end

end
