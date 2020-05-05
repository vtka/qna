class LinksController < ApplicationController
  before_action :authenticate_user!
  expose :link

  def destroy
    return head :forbidden unless current_user.author_of?(link.linkable)

    link.destroy
  end
end
