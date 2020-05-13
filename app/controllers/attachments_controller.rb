class AttachmentsController < ApplicationController

  before_action :authenticate_user!, only: %i[destroy]
  before_action :find_attachment, only: %i[destroy]

  authorize_resource


  def destroy
    if current_user.author?(@attachment.record)
      @attachment.purge
    else
      return render(file: Rails.root.join('public', '302'), formats: [:html], status: 302, layout: false)
    end
  end

  private
  
  def find_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end

end
