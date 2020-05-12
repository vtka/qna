module GlobalHelpers
  def oauth_response(options = {})
    return unless options[:provider].present?

    auth_data = {
      'provider' => options[:provider].to_s,
      'uid' => '123',
      'info' => { 'email' => 'user@example.com' }
    }

    auth_data['info'] = {} if options[:skip_email] == true
    auth_hash = OmniAuth::AuthHash.new(auth_data)
    OmniAuth.config.mock_auth[options[:provider].to_sym] = auth_hash
    auth_hash
  end
end