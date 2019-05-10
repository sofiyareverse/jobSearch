class Candidate < ApplicationRecord
  validates_presence_of :job, :user

  belongs_to :user
  belongs_to :job
end
