class AddIsDeactivatedToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :is_deactivated, :boolean, :default => false
  end

  def self.down
    remove_column :groups, :is_deactivated
  end
end
