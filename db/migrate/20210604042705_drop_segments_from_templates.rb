class DropSegmentsFromTemplates < ActiveRecord::Migration[6.1]
  def change
    remove_column :templates, :segment
  end
end
