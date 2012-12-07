class AddDeletedToDashboards < ActiveRecord::Migration
  def self.up
    add_column :dashboards, :deleted, :boolean, :default => false
  end

  def self.down
    remove_column :dashboards, :deleted
  end
end
