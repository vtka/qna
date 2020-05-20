class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: %i[index show]

  def index
    @answers = @question.answers
    render json: @answers
  end

  def show
    @answer = @question.answers.find(params[:id])
    render json: @answer
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end
end