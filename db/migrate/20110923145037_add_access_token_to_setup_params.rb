class AddAccessTokenToSetupParams < ActiveRecord::Migration
  def self.up
    add_column :setup_params, :access_token, :string
  end

  def self.down
    remove_column :setup_params, :access_token
  end
end
