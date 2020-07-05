# frozen_string_literal: true

module ApplicationHelper
  CONTEXTUAL_CLASSES = {
    'alert' => 'danger'
  }.freeze

  def flash_contextual_class(key)
    CONTEXTUAL_CLASSES[key] || 'success'
  end
end
