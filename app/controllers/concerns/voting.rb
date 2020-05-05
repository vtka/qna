module Voting
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, only: %i[upvote downvote]
    expose :parent_resource, -> { resource_klass.find(params[:id]) }
  end

  def upvote
    vote(:upvote)
  end

  def downvote
    vote(:downvote)
  end

  private

  def vote(type)
    return head :forbidden if current_user&.author_of?(parent_resource)

    return head :conflict unless parent_resource.send(type, current_user)

    render json: {
      resource: parent_resource.model_name.param_key,
      id: parent_resource.id,
      votetype: type,
      votecount: parent_resource.votecount
    }
  end

  def resource_klass
    controller_name.classify.constantize
  end
end
