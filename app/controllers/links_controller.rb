class LinksController < ApplicationController

  before_action :authenticate_user!, only: %i[destroy]
  before_action :find_link, only: %i[destroy]

  def destroy
    if current_user.author?(@link.linkable)
      @link.destroy
    else
      return render(file: Rails.root.join('public', '403'), formats: [:html], status: 403, layout: false)
    end
  end

  private

  def find_link
    @link = Link.find(params[:id])
  end

end
