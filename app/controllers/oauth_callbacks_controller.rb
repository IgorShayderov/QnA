# frozen_string_literal: true

class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    authenticate_through_oauth
  end

  def vkontakte
    authenticate_through_oauth
  end

  private

  def authenticate_through_oauth
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      p '11111111111111 user persisted'
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: action_name.capitalize) if is_navigational_format?
    elsif @user.new_record?
      p '222222222222 user not persisted'
      session['devise.oauth_uid'] = auth.uid
      session['devise.oauth_provider'] = auth.provider
      redirect_to new_user_confirmation_path
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
