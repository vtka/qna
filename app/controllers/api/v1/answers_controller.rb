class Api::V1::AnswersController < Api::V1::BaseController
  def index
    @question = Question.find(params[:question_id])

    @answers = @question.answers
    render json: @answers
  end
end