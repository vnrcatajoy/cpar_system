class CausesController < ApplicationController
  before_filter :signed_in_user

  def show
    @cause=Cause.find(params[:id])
  end

  #add filter later like in public issues controller, to limit who 
  #could view Issue/Causes page, same for Action Plan

end
