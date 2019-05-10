class CreateJobsUsersJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :jobs, :users do |t|
      t.index :job_id
      t.index :user_id
    end
  end
end
