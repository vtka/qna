class ApplicationController < ActionController::Base
  before_action :gon_user, unless: :devise_controller?
  
  def gon_user
    gon.current_user = current_user.id if current_user
  end
end
