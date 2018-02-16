class GithubStatusClient
  def post_status(run, state: 'pending', target_url: '', description: '', context: '')
    # state	string	Required. The state of the status. Can be one of error, failure, pending, or success.
    # target_url	string	The target URL to associate with this status.
    #                                                                                                                                                                        http://ci.example.com/user/repo/build/sha
    # description	string	A short description of the status.
    # context	string	A string label to differentiate this status from the status of other systems. Default: default
    if run.state != state
      run.update!(state: state)

      if run.access_token.nil? || run.access_token_expires < Time.now
        run.update!(access_token: get_access_token['token'], access_token_expires: DateTime.parse(get_access_token['expires_at']))
      end

      HTTParty.post("https://api.github.com/repos/virtuosolearning/virtuoso/commits/#{run.sha.strip}/statuses",
                    body: {
                        state: state,
                        target_url: target_url,
                        description: description,
                        context: context
                    }.to_json,
                    headers: token_header(run.access_token))

    end
  end

  def token_header(access_token)
    {
        "Authorization" => "token #{access_token}"
    }.merge(headers)
  end

  def get_access_token
    @access_token ||= {}
    if @access_token['expires_at'].nil? || DateTime.parse(@access_token['expires_at']) < Time.now
      response = HTTParty.post('https://api.github.com/installations/87728/access_tokens',
                               headers: jwt_header)
      @access_token = JSON.parse(response.body)
    else
      @access_token
    end
  end

  def jwt_header
    {
        "Authorization" => "Bearer #{get_jwt}"
    }.merge(headers)
  end

  def headers
    {
        "Accept" => "application/vnd.github.machine-man-preview+json",
        "User-Agent" => "ruby"
    }
  end

  def get_jwt
    private_pem = ENV['GITHUB_PRIVATE']
    private_key = OpenSSL::PKey::RSA.new(private_pem)

    payload = {
        # issued at time
        iat: Time.now.to_i,
        # JWT expiration time (10 minute maximum)
        exp: Time.now.to_i + (10 * 60),
        # GitHub App's identifier
        iss: 9084
    }

    JWT.encode(payload, private_key, "RS256")
  end
end
