class CreateKships < ActiveRecord::Migration
  def change
    create_table :kships do |t|
      t.integer :keyword_id
      t.integer :rel_keyword_id

      t.timestamps null: false
    end
  end
end
