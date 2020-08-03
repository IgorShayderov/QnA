# frozen_string_literal: true

class FindForOauth
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.find_by(auth_params)
    return authorization.user if authorization

    find_or_create_user

    if @user.persisted?
      @user.authorizations.create!(auth_params)
      @user.confirm unless @user.confirmed?
    end
    @user
  end

  private

  def password
    @password ||= Devise.friendly_token[0, 20]
  end

  def find_or_create_user
    @user =
      if !email.blank?
        User.find_by(email: email) ||
          User.create(
            email: email,
            password: password,
            password_confirmation: password
          )
      else
        User.new
      end
  end

  def email
    @auth.info[:email]
  end

  def auth_params
    { provider: @auth.provider, uid: @auth.uid.to_s }
  end
end
