class QuestionsController < ApplicationController
  include Voted
  
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :new_comment, only: %i[show update]
  before_action :find_subscription, only: %i[show update]
  after_action :publish_question, only: %i[create]

  authorize_resource 

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
    @question.build_badge
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
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Your question was successfully deleted.'
  end

  private

  def new_comment
    @comment = Comment.new
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, 
                                     files: [],
                                     links_attributes: [:name, :url, :_destroy],
                                     badge_attributes: [:name, :image])
  end

  def publish_question
    return if @question.errors.any?
    
    ActionCable.server.broadcast(
      'question_channel',
      ApplicationController.render(
        partial: 'questions/question', 
        locals: { question: @question }
        )
      )
  end

  def find_subscription
    @subscription = current_user.subscriptions
      .find_by(question_id: @question) if current_user
  end
end
