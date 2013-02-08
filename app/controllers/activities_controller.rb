class ActivitiesController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user,   only: [:edit, :update]

  def new
    @activity = Activity.new
  end

  def create
    @activity = Activity.new(params[:activity])
  end

  def show
  end

  def edit
  end

  def update
  end

end