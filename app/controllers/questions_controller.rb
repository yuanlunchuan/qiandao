class QuestionsController < ApplicationController
  layout 'event'

  def index
    @questions = current_event.question
  end

  def show
    @question = Question.find(params[:id])
    if @question.answer.present?
      @answer   = @question.answer
    else
      @answer = Answer.new
    end
  end

  def edit
    
  end

  def update
    logger.info "---------params: #{params}"
    admin = Admin.auth_token_is(cookies[:auth_token]).first
    question = Question.find(params[:id])

    if params[:answer_id].present?
      answer = Answer.find(params[:answer_id])
      answer.update admin: admin, question: question, answer: params[:answer]
    else
      Answer.create admin: admin, question: question, answer: params[:answer]
    end

    redirect_to event_questions_path(current_event)
  end

end