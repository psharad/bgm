class AddAboutToAdmins < ActiveRecord::Migration
  def self.up
    add_column :admins, :about, :text
  end

  def self.down
    remove_column :admins, :about
  end
end
