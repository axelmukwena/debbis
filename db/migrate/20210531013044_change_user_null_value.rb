class ChangeUserNullValue < ActiveRecord::Migration[6.1]
  def change
    change_column_null :members, :users_id, false
  end
end
