class CreatePeople < ActiveRecord::Migration[6.1]
  def change
    create_table :people do |t|
      t.integer :identity
      t.integer :node
      t.string :name
      t.string :gender
      t.string :age

      t.timestamps
    end
    add_index :people, :identity, unique: true
  end
end
