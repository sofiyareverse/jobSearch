class Job < ApplicationRecord
  has_many :candidates
  has_many :users, through: :candidates
end
