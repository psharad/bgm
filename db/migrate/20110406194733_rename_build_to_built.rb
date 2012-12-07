class RenameBuildToBuilt < ActiveRecord::Migration
  def self.up
    rename_table :builds, :builts
    rename_column :users, :build_id, :built_id
    rename_column :members, :build_id, :built_id
  end

  def self.down
    rename_table :builts, :builds
    rename_column :users, :build_id, :built_id
    rename_column :members, :build_id, :built_id
  end
end
