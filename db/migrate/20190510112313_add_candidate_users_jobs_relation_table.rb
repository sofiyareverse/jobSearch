class AddCandidateUsersJobsRelationTable < ActiveRecord::Migration[5.1]
  def change
    create_table :candidates do |t|
      t.belongs_to :job, null: false, index: true
      t.belongs_to :user, null: false, index: true
      t.datetime :applied_at
    end
  end
end
