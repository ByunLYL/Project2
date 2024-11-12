class User < ApplicationRecord
  authenticates_with_sorcery!

  attr_accessor :password, :password_confirmation, :token

  CELLPHONE_RE = /\A(\+86|86)?1\d{10}\z/
  EMAIL_RE = /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/

  # validates_presence_of :email, message: "emial cannot be empty"
  # validates_format_of :email, message: "The mailbox format is incorrect",
  #   with: /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/,
  #   if: proc { |user| !user.email.blank? }
  # validates :email, uniqueness: true

  validates_presence_of :password, message: "The password cannot be empty",
    if: :need_validate_password
  validates_presence_of :password_confirmation, message: "The password confirmation cannot be empty",
    if: :need_validate_password
  validates_confirmation_of :password, message: "Password inconsistency",
    if: :need_validate_password
  validates_length_of :password, message: "The minimum password is 6 characters", minimum: 6,
    if: :need_validate_password

  validate :validate_email_or_cellphone, on: :create

  has_many :addresses, -> { where(address_type: Address::AddressType::User).order("id desc") }
  belongs_to :default_address, class_name: :Address
  has_many :orders
  has_many :payments

  def username
    self.email.blank? ? self.cellphone : self.email.split('@').first
  end

  private
  def need_validate_password
    self.new_record? ||
      (!self.password.nil? || !self.password_confirmation.nil?)
  end

  # TODO
  def validate_email_or_cellphone
    if [self.email, self.cellphone].all? { |attr| attr.nil? }
      self.errors.add :base, "The email address and mobile phone number cannot be empty"
      return false
    else
      if self.cellphone.nil?
        if self.email.blank?
          self.errors.add :email, "The mailbox cannot be empty"
          return false
        else
          unless self.email =~ EMAIL_RE
            self.errors.add :email, "The mailbox format is incorrect"
            return false
          end
        end
      else
        unless self.cellphone =~ CELLPHONE_RE
          self.errors.add :cellphone, "The format of the mobile phone number is incorrect"
          return false
        end

        unless VerifyToken.available.find_by(cellphone: self.cellphone, token: self.token)
          self.errors.add :cellphone, "Mobile phone verification code is incorrect or expired"
          return false
        end
      end
    end

    return true
  end
end

