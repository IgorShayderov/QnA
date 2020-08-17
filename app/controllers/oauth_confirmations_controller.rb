# frozen_string_literal: true

class OauthConfirmationsController < Devise::ConfirmationsController
  def new; end

  def create
    password = Devise.friendly_token[0, 20]
    @user = User.new(oauth_confirmation_params.merge(password: password, password_confirmation: password))

    if @user.save
      @user.send_confirmation_instructions
      render plain: "Email confirmation has been send to #{oauth_confirmation_params[:email]}"
    else
      flash[:alert] = 'Invalid email'
      render :new
    end
  end

  private

  def after_confirmation_path_for(_resource_name, user)
    user.authorizations.create(provider: session['devise.oauth_provider'], uid: session['devise.oauth_uid'])
    signed_in_root_path(user)
  end

  def oauth_confirmation_params
    params.permit(:email)
  end
end
