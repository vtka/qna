class LinksController < ApplicationController

  before_action :authenticate_user!, only: %i[destroy]
  before_action :find_link, only: %i[destroy]

  authorize_resource

  def destroy
    if current_user.author?(@link.linkable)
      @link.destroy
    else
      return render(file: Rails.root.join('public', '302'), formats: [:html], status: 302, layout: false)
    end
  end

  private

  def find_link
    @link = Link.find(params[:id])
  end

end
