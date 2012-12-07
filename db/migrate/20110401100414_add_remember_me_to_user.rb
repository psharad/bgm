class AddRememberMeToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :remember_me, :boolean, :default => true
  end

  def self.down
    remove_column :users, :remember_me
  end
end
