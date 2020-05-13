class AnswersController < ApplicationController
  include Voted
  
  before_action :authenticate_user!, except: %i[destroy create update best]
  before_action :find_question, only: %i[new create]
  before_action :find_answer, only: %i[destroy update best]
  before_action :new_comment, only: %i[show update create best]
  after_action :publish_answer, only: %i[create]

  authorize_resource

  def show; end

  def new
    @answer = @question.answers.new
  end

  def edit; end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      flash[:notice] = 'Your answer was successfully created.'
    end
  end

  def destroy
    @answer.destroy
  end

  def best
    @answer.best!
  end

  private

  def new_comment
    @comment = Comment.new
  end

  def gon_author
    gon.author = @answer.author.id
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, 
                                   files: [],
                                   links_attributes: [:name, :url, :_destroy])
  end

  def publish_answer
    return if @answer.errors.any?
    
    renderer = ApplicationController.renderer_with_user(current_user)

    @question = @answer.question

    AnswerChannel.broadcast_to(
      @question,
      { 
        author_id: @answer.author.id,
        body: renderer.render(partial: 'answers/guest_answer', locals: { answer: @answer }) 
      }
    )
  end
end
