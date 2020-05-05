class AwardsController < ApplicationController
  before_action :authenticate_user!
  expose :awards, -> { current_user.awards.with_attached_image }

  def index; end
end
