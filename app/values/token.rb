class Token
  attr_reader :token

  def initialize
    @token = SecureRandom.urlsafe_base64
  end

  def digest
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : 
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(token, cost: cost)
  end

end
