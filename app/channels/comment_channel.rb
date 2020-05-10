class CommentChannel < ApplicationCable::Channel
  def subscribed
    resource = GlobalID::Locator.locate(params[:id])
    stream_for resource
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
