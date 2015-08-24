class AddKeywordsIdsToKrakes < ActiveRecord::Migration
  def change
    add_column :krakes, :keyword_ids, :string
  end
end
