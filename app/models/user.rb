class User < ApplicationRecord
  require 'csv'

  has_many :notes
  has_and_belongs_to_many :jobs

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      new_rows_hash = modefy_file_headers(row)
      
      User.create!(
        name: new_rows_hash[:name],
        email: new_rows_hash[:email],
        phone: new_rows_hash[:phone]
      )
    end
  end

  def modefy_file_headers(row)
    row.inject({}) do |h, (k, v)|
      h[k.downcase.tr(' ', '_').delete('-').to_sym] = v; h
    end
  end
end
