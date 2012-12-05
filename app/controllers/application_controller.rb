class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  before_filter :instantiateUser
  before_filter :instantiateTurf

  def instantiateUser
    @user = User.new
  end

  def instantiateTurf
    @turf = Turf.new
  end


end
