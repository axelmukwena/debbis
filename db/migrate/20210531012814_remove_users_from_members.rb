class RemoveUsersFromMembers < ActiveRecord::Migration[6.1]
  def change
    remove_column :members, :users_id
  end
end
