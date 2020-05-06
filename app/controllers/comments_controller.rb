class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_resource, only: %i[create]

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
end
