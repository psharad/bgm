class AddFbFriendsToSetupParams < ActiveRecord::Migration
  def self.up
    add_column :setup_params, :fb_friends, :blob
  end

  def self.down
    remove_column :setup_params, :fb_friends
  end
end
