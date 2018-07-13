class QuestionsController < ApplicationController

  def index
     render json: Question.all, status: :ok
  end

  def show
    @question = Question.find_by(id: params[:id])
    if @question
      render json: @question, status: :ok
    else
      render json: {message: "Could not find question with id:#{params[:id]}"}, status: :not_found
    end
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      render json: @question, status: :created
    else
      render json: {message: "Could not create question record : content can't be blank"}, status: :invalid_record
    end
  end

  def update
    @question = Question.find_by(id: params[:id])
    if @question
      if @question.update(question_params)
        head :no_content
      else
        render json: {message: "Could not update question record : content can't be blank"}
      end
    else
      render json: {message: "Could not find question with id:#{params[:id]}"}, status: :not_found
    end
  end

  def destroy
    @question = Question.find_by(id: params[:id])
    if @question
      @question.destroy
      head :no_content
    else
      render json: {message: "Could not find question with id:#{params[:id]}"}, status: :not_found
    end
  end

  private

  def question_params
    params.permit(:content)
  end

end
