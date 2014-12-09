class AddUsersToStory < ActiveRecord::Migration
  def change
    rename_column :stories, :author, :user_id
  end
end
