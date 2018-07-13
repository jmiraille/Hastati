class QuestionsController < ApplicationController

  def index
     render json: Question.all, status: :ok
  end

  def show
    @question = Question.find_by(id: params[:id])
    render json: @question, status: :ok
  end

  def create
  end

end
