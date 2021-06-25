class ChangeUserIdDefault < ActiveRecord::Migration[6.1]
  def change
    change_column_default :members, :users_id, null: false
  end
end
