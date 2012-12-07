class AddHistoryToMember < ActiveRecord::Migration
  def self.up
    add_column :members, :in_history, :boolean, :default => true
  end

  def self.down
    remove_column :members, :in_history
  end
end
