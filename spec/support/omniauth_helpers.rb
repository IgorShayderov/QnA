module OmniAuthHelpers
  def mock_auth(user)
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      provider: 'github',
      uid: '955504',
      info: {
        email: user.email
      }
    })
  end
end
