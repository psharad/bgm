class AddNameAndSavePasswordToAdmins < ActiveRecord::Migration
  def self.up
    add_column :admins, :name, :string
    add_column :admins, :save_password, :string
  end

  def self.down
    remove_column :admins, :save_password
    remove_column :admins, :name
  end
end
