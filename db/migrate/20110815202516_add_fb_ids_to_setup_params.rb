class AddFbIdsToSetupParams < ActiveRecord::Migration
  def self.up
    add_column :setup_params, :fb_ids, :text
  end

  def self.down
    remove_colummn :setup_params, :fb_ids
  end
end
