class AddKrakeIdToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :krake_id, :integer
  end
end
