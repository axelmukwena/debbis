class RenameUsersIdToUserId < ActiveRecord::Migration[6.1]
  def change
    rename_column(:members, :users_id, :user_id)
  end
end
