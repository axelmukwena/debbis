class CreateMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :members do |t|
      t.integer :identity
      t.integer :node
      t.string :name
      t.string :gender
      t.string :age

      t.timestamps
    end
    add_index :members, :identity, unique: true
  end
end