# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render json: exception.message }
      format.html { redirect_to root_url, alert: exception.message }
      format.js { head :forbidden, content_type: 'text/html' }
    end
  end

  check_authorization unless: :devise_controller?
end
