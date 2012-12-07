class AddSetupFlagToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :setup_flag, :boolean, :default => false
    
    User.all.each do |u|
      done = u.groups.current_group.preference.present? rescue false
      u.update_attribute(:setup_flag, done)
    end
  end

  def self.down
    remove_column :users, :setup_flag
  end
end
