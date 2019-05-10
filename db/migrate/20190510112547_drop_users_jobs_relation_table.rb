class DropUsersJobsRelationTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :jobs_users
  end
end
