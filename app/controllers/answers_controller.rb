class AnswersController < ApplicationController
  include Voted
  
  before_action :authenticate_user!, except: %i[destroy create update best]
  before_action :find_question, only: %i[new create]
  before_action :find_answer, only: %i[destroy update best]
  after_action :publish_answer, only: %i[create]

  def show; end

  def new
    @answer = @question.answers.new
  end

  def edit; end

  def update
    if current_user.author?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
    end
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      flash[:notice] = 'Your answer was successfully created.'
    end
  end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
    else
      return render(file: Rails.root.join('public', '403'), formats: [:html], status: 403, layout: false)
    end
  end

  def best
    if current_user.author?(@answer.question)
      @answer.best!
    end
  end

  private
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

  def answer_files
    @answer.files.map do |file|
          {
            id: file,
            name: file.filename.to_s,
            url: url_for(file) 
          }
    end
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "question-#{@question.id}-answers",
        answer: @answer,
        question_author: @answer.question.author,
        files: answer_files,
        links: @answer.links
        )
  end
end
