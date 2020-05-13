class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_resource, only: %i[create]
  after_action :publish_comment, only: %i[create]

  authorize_resource

  def create
    @comment = @resource.comments.new(comment_params)
    @comment.author = current_user

    if @comment.save
      flash.now[:notice] = 'Comment posted successfully'
    end
  end

  private

  def find_resource
    @klass = [Question, Answer].find { |klass| params["#{klass.name.underscore}_id"] }
    @resource = @klass.find(params["#{@klass.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?
    
    renderer = ApplicationController.renderer_with_user(current_user)

    CommentChannel.broadcast_to(
      @resource,
      { 
        author_id: @comment.author.id,
        resource_type: @resource.class.name.downcase,
        resource_id: @resource.id,
        body: renderer.render(partial: 'comments/comment', locals: { comment: @comment }) 
      }
    )
  end
end
