class AttachmentsController < ApplicationController

  before_action :authenticate_user!, only: %i[destroy]
  before_action :find_attachment, only: %i[destroy]

  def destroy
    if current_user.author?(@attachment.record)
      @attachment.purge
    else
      return render(file: Rails.root.join('public', '403'), formats: [:html], status: 403, layout: false)
    end
  end

  private
  def find_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end

end
