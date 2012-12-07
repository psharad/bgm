class AddInCollegeField < ActiveRecord::Migration
  def self.up
    add_column :members, :in_college, :boolean, :default => false
    add_column :users, :in_college, :boolean, :default => false
  end

  def self.down
    remove_column :members, :in_college
    remove_column :users, :in_college
  end
end
