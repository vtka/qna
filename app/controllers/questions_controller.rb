class QuestionsController < ApplicationController
  include Voting

  before_action :authenticate_user!, except: %i[index show]

  expose :question, find: ->(id, scope) { scope.with_attached_files.find(id) }
  expose :questions, -> { Question.all }
  expose :answer, -> { Answer.new }

  def show
    answer.links.new
  end

  def new
    question.links.new
    question.build_award
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question was successfully created.'
    else
      render :new
    end
  end

  def update
    return head :forbidden unless current_user.author_of?(question)

    question.update(question_params)
  end

  def destroy
    return head :forbidden unless current_user.author_of?(question)

    question.destroy
    redirect_to questions_path, notice: 'Your question was successfully deleted.'
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                     links_attributes: %i[id name url _destroy],
                                     award_attributes: %i[id title image _destroy])
  end
end
