class AddTemplatesCountToMembers < ActiveRecord::Migration[6.1]
  def change
    add_column :members, :templates_count, :integer
  end
end
