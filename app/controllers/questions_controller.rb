class QuestionsController < ApplicationController
  layout 'event'
  before_action :set_current_module

  def choose_event_question
    @event_questions = current_event.event_questions
    render layout: 'empty'
  end

  def index
    @event_question = EventQuestion.find params[:event_question_id]
    @questions = @event_question.questions
    render layout: 'empty'
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
    question = Question.find(params[:question_id])
    event_question = EventQuestion.find(params[:event_question_id])
    praise_count = params[:praise_count]
    question.update praise_count: praise_count
    # admin = Admin.auth_token_is(cookies[:auth_token]).first
    # question = Question.find(params[:id])

    # if params[:answer_id].present?
    #   answer = Answer.find(params[:answer_id])
    #   answer.update admin: admin, question: question, answer: params[:answer]
    # else
    #   Answer.create admin: admin, question: question, answer: params[:answer]
    # end

    redirect_to event_event_question_path(current_event, event_question), flash: {success: '点赞成功'}
  end

  def set_current_module
    @current_module = 4
  end

end