class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.text :description
      t.text :url
      t.integer :entry_type

      t.timestamps null: false
    end
  end
end
