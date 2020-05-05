class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  expose :attachment, -> { ActiveStorage::Attachment.find(params[:id]) }

  def destroy
    return head :forbidden unless current_user.author_of?(attachment.record)

    attachment.purge
  end
end
