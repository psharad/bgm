class AddPreferencePhotoIdToSetupParams < ActiveRecord::Migration
  def self.up
    add_column :setup_params, :preference, :text
    add_column :setup_params, :photo_id, :integer
  end

  def self.down
    remove_column :setup_params, :preference
    remove_column :setup_params, :photo_id
  end
end
