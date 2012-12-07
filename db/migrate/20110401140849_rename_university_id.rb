class RenameUniversityId < ActiveRecord::Migration
  def self.up
    change_column :users, :university_id, :string
    change_column :members, :university_id, :string
    rename_column :users, :university_id, :university
    rename_column :members, :university_id, :university
  end

  def self.down
  end
end
