module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: %i[positive negative revote]
  end

  def positive
    unless current_user&.author?(@votable)
      @votable.positive(current_user)

      render_json
    end
  end

  def negative
    unless current_user&.author?(@votable)
      @votable.negative(current_user)

      render_json
    end
  end

  def revote
    @votable.votes.find_by(user_id: current_user)&.destroy

    render_json
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def find_votable
    @votable = model_klass.find(params[:id])
  end

  def render_json(*flash)
    render json: {
                   score: @votable.rating,
                   klass: @votable.class.to_s,
                   id: @votable.id,
                   flash: flash
                 }
  end
end