class CreateKrakes < ActiveRecord::Migration
  def change
    create_table :krakes do |t|
      t.integer :keywords, array: true, default: []
      t.timestamps null: false
    end
  end
end
