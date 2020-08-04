# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: %i[create destroy]

  after_action :publish_comment, only: %i[create]

  authorize_resource

  def create
    @comment = @commentable.comments.create(comment_params.merge(user: current_user))
  end

  private

  def commentable_class
    if params[:question_id]
      Question
    elsif params[:answer_id]
      Answer
    else
      raise 'No commentable params for comments controller'
    end
  end

  def commentable_class_str
    commentable_class.name.underscore
  end

  def set_commentable
    @commentable = commentable_class.find(params["#{commentable_class_str}_id".to_sym])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?

    question_id = @commentable[:question_id] || @commentable[:id]

    ActionCable.server.broadcast("questions/#{question_id}/comments", {
                                   template: ApplicationController.render(
                                     partial: 'comments/comment',
                                     locals: { comment: @comment }
                                   ),
                                   resource_name: commentable_class_str,
                                   resource_id: @commentable.id
                                 })
  end
end
