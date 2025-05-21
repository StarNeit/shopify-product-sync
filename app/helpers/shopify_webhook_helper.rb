module ShopifyWebhookHelper
  def self.verify_webhook(data, hmac_header, secret)
    calculated_hmac = Base64.strict_encode64(
      OpenSSL::HMAC.digest(
        OpenSSL::Digest.new('sha256'),
        secret,
        data
      )
    )
    ActiveSupport::SecurityUtils.secure_compare(calculated_hmac, hmac_header)
  end

  def self.generate_hmac(data, secret)
    Base64.strict_encode64(
      OpenSSL::HMAC.digest(
        OpenSSL::Digest.new('sha256'),
        secret,
        data
      )
    )
  end
end 