class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[destroy create]
  before_action :find_question, only: %i[new create]
  before_action :find_answer, only: :destroy

  def show; end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      redirect_to @question, notice: 'Your answer was successfully created.'
    # else
    #   respond_to do |format|
    #     format.js { render layout: false }
    #   end
    end
  end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'Your answer was successfully deleted.'
    else
      return render(file: Rails.root.join('public', '403'), formats: [:html], status: 403, layout: false)
    end
  end

  private
    def find_question
      @question = Question.find(params[:question_id])
    end

    def find_answer
      @answer = Answer.find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:body)
    end
end
