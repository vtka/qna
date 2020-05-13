class BadgesController < ApplicationController

  before_action :authenticate_user!, only: %i[index]

  authorize_resource

  def index; end

end
