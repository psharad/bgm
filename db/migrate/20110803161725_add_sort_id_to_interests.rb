class AddSortIdToInterests < ActiveRecord::Migration
  def self.up
    add_column :interests, :sort_id, :integer, :default => 0
  end

  def self.down
    remove_column :interests, :sort_id
  end
end
