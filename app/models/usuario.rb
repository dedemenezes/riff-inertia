class Usuario < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  alias_attribute :created_at, :created
  alias_attribute :updated_at, :updated

  def valid_password?(password)
    return super if encrypted_password.present?
    return false if senha.blank?
    return false unless Digest::MD5.hexdigest(password) == senha

    self.password = password
    self.senha = ""
    save(validate: false)
    true
  end

  def active_for_authentication?
    super && ativo
  end

  def inactive_message
    ativo ? super : :inactive
  end
end
