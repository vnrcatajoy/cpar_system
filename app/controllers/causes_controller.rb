class CausesController < ApplicationController
  before_filter :signed_in_user

  def show
    @cause=Cause.find(params[:id])
  end

end
