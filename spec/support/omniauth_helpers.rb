# frozen_string_literal: true

module OmniAuthHelpers
  def mock_auth_hash(provider, options = {})
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
                                                                   provider: provider.to_s,
                                                                   uid: '12345',
                                                                   info: {
                                                                     email: options[:email] || 'test@google.com'
                                                                   }
                                                                 })
  end
end
