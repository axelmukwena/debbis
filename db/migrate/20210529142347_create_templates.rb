class CreateTemplates < ActiveRecord::Migration[6.1]
  def change
    create_table :templates do |t|
      t.text :segment, null: false
      t.references :member, null: false, foreign_key: true

      t.timestamps
    end
  end
end
