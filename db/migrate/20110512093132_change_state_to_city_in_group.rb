class ChangeStateToCityInGroup < ActiveRecord::Migration
  def self.up
    remove_column :groups, :state_id
    add_column :groups, :city_id, :integer
  end

  def self.down
    add_column :groups, :state_id, :integer
    remove_column :groups, :city_id
  end
end
