class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :find_question, only: %i[show update]

  authorize_resource

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question
  end

  def create
    @question = Question.create(question_params)
    @question.author = current_resource_owner

    if @question.save
      render json: @question, status: 201
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      render json: @question, status: :created
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
