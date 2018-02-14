class JwtGenerator
  def self.generate
    private_pem = File.read(Rails.root.join('visual-qa.2018-02-14.private-key.pem'))
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
