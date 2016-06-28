class EventQuestionsController < ApplicationController
  layout 'event'
  before_action :set_current_module

  def create
    @event_question = current_event.event_questions.new event_question_params
    if @event_question.save
      redirect_to event_event_questions_path(current_event), flash: { success: '添加成功' }
    else
      flash[:error] = @event_question.errors.full_messages
      render :new
    end
  end

  def new
    @event_question = current_event.event_questions.build
  end

  def index
    @event_questions = current_event.event_questions
  end

  def update
    @event_question = EventQuestion.find params[:id]
    if @event_question.update event_question_params
      redirect_to event_event_questions_path(current_event), flash: { success: '更新成功' }
    else
      flash[:error] = @event_question.errors.full_messages
      render :edit
    end
  end

  def edit
    @event_question = EventQuestion.find params[:id]
  end

  def destroy
    @event_question = EventQuestion.find params[:id]
    @event_question.destroy
    redirect_to event_event_questions_path(current_event), flash: { success: '删除成功' }
  end

  def event_question_params
    params.require(:event_question).permit(:name)
  end

  def set_current_module
    @current_module = 4
  end
end
