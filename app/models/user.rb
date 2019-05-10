class User < ApplicationRecord
  require 'csv'

  has_many :notes
  has_and_belongs_to_many :jobs

  validates :name, presence: true
  validate :email_format
  validates :phone,
            numericality: true,
            length: { minimum: 0, maximum: 50 },
            allow_blank: true

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      new_rows_hash = modefy_file_headers(row)
      
      if User.where(email: new_rows_hash[:email]).count > 0
        true
      else
        User.create!(
          name: new_rows_hash[:name],
          email: new_rows_hash[:email],
          phone: self.try(:phone) || new_rows_hash[:phone]
        )
      end
    end
  end

  private

  def self.modefy_file_headers(row)
    row.inject({}) do |h, (k, v)|
      h[k.downcase.tr(' ', '_').delete('-').to_sym] = v; h
    end
  end

  def email_format
    unless email.match?(URI::MailTo::EMAIL_REGEXP)
      if email.match?('^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')
        self.phone = email
        self.email = nil
      else
        errors.add(:email, 'Wrong format')
      end
    end
  end
end
