# frozen_string_literal: true

class AttachmentsController < ApplicationController
  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    @attachment.purge if current_user&.author_of?(@attachment.record)
  end
end
