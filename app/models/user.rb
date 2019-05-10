class User < ApplicationRecord
  require 'csv'

  has_many :notes
  has_and_belongs_to_many :jobs

  validate :email_format
  validates :phone,
            numericality: true,
            length: { minimum: 0, maximum: 50 },
            allow_blank: true

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      new_rows_hash = modefy_file_headers(row)

    unless User.where(email: new_rows_hash[:email]).blank?
      User.find_by(email: new_rows_hash[:email]).update!(
        name: new_rows_hash[:name],
        phone: new_rows_hash[:phone]
      )
    else
      User.create!(
        name: new_rows_hash[:name],
        email: new_rows_hash[:email],
        phone: self.try(:phone) || new_rows_hash[:phone]
      )
    end

      find_or_create_note(new_rows_hash) if new_rows_hash[:note]
      find_or_create_job(new_rows_hash) if new_rows_hash[:job]
    end
  end

  private

  def self.modefy_file_headers(rows)
    rows.inject({}) do |h, (k, v)|
      h[k.downcase.tr(' ', '_').delete('-').to_sym] = v; h
    end
  end

  def self.find_or_create_note(rows)
    user_id = User.find_by(email: rows[:email]).id

    if Note.where(user_id: user_id, message: rows[:note]).blank?
      Note.create!(message: rows[:note], user_id: user_id)
    end
  end

  def self.find_or_create_job(rows)
    user_id = User.find_by(email: rows[:email])

    if Job.where(title: rows[:job]).blank?
      job = Job.create!(title: rows[:job])
      job.users << user_id
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
