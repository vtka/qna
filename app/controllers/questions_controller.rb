class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
  end

  def new
    @question = Question.new
    @question.links.new
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question was successfully created.'
    else
      render :new
    end
  end

  def update
    if current_user.author?(@question)
      @question.update(question_params)
    end
  end

  def destroy
    unless current_user.author?(@question)
      return render(file: Rails.root.join('public', '403'), formats: [:html], status: 403, layout: false)
    end

    @question.destroy
    redirect_to questions_path, notice: 'Your question was successfully deleted.'
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, 
                                     files: [],
                                     links_attributes: [:name, :url])
  end
end
