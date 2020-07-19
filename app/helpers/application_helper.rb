# frozen_string_literal: true

module ApplicationHelper
  CONTEXTUAL_CLASSES = {
    'alert' => 'danger'
  }.freeze

  def flash_contextual_class(key)
    CONTEXTUAL_CLASSES[key] || 'success'
  end

  def resource_name(resource)
    resource.class.name.downcase
  end
end
