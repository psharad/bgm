class AddColumnsToCity < ActiveRecord::Migration
  def self.up
    add_column :cities, :state, :string
    add_column :cities, :abbrev, :string
    add_column :cities, :priority, :boolean, :default => false
  end

  def self.down
    remove_column :cities, :state
    remove_column :cities, :abbrev
    remove_column :cities, :priority
  end
end
