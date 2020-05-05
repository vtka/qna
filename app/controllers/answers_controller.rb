class AnswersController < ApplicationController
  include Voting

  before_action :authenticate_user!, except: %i[index show]

  expose :answer, find: ->(id, scope) { scope.with_attached_files.find(id) }
  expose :question, -> { Question.find(params[:question_id]) }

  def create
    @answer = question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    return head :forbidden unless current_user.author_of?(answer)

    answer.update(answer_params)
  end

  def destroy
    return head :forbidden unless current_user.author_of?(answer)

    answer.destroy
  end

  def accept
    return head :forbidden unless current_user.author_of?(answer.question)

    answer.accept!
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id name url _destroy])
  end
end
