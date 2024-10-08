class User < ApplicationRecord
  authenticates_with_sorcery!

  has_one :dog
  has_one :cat

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true

  # Sorceryのremember_me機能を利用するための設定
  attr_accessor :remember_me_token, :remember_me_token_expires_at

  def remember_me_for
    7.days
  end
end
