# frozen_string_literal: true

module VotableController
  extend ActiveSupport::Concern

  def vote

  end

  def unvote
    
  end

  def model_klass
    controller_name.classify.constantize
  end
end
