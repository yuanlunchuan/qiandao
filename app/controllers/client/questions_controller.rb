class Client::QuestionsController < ApplicationController
  layout 'client'
  skip_before_action :verify_authenticity_token

  def index
    @current_event_question = current_event.event_questions.active.first
    @questions = @current_event_question.try(:questions)
    @current_attendee = Attendee.find(cookies[:attendee_id])
  end

  def praises
    attendee = Attendee.find(cookies[:attendee_id])
    question = Question.find(params[:question_id])
    event_question = EventQuestion.find(params[:event_question_id])
    result = {}
    attendee_praise_question = AttendeePraisesQuestion.get_praise(attendee, question)
    if attendee_praise_question.blank?
      AttendeePraisesQuestion.create attendee: attendee,
        question: question,
        event_question: event_question
      question.update praise_count: (question.praise_count+1)
      result[:praise_success] = true
    else
      attendee_praise_question.first.delete
      question.update praise_count: (question.praise_count-1)
      result[:cancel_success] = true
    end
    result[:praise_count] = question.praise_count

    render :json =>result.to_json
  end
  
  def create
    question = Question.new question_content: params[:question],
      event: current_event,
      event_question: EventQuestion.find(params[:event_question_id]),
      attendee: Attendee.find(cookies[:attendee_id])
    question.save
    redirect_to client_event_event_question_questions_path(current_event, params[:event_question_id])
  end

  def new

  end
end
