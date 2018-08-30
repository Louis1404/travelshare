class ProfilesController < ApplicationController

  def show
    authorize @profile
  end

  def edit
    @profile = Profile.find(params[:id])
    authorize @profile
  end

  def update
    if @profile.update(params_profile)
      redirect_to profile_path
    else
      render :edit
    end

    authorize @profile
  end

end
