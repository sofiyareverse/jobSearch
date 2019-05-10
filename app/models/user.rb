class User < ApplicationRecord
  has_many :notes
  has_and_belongs_to_many :jobs
end
