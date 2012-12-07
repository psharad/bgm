class AddBloggerToAdmins < ActiveRecord::Migration
  def self.up
    add_column :admins, :blogger, :boolean
  end

  def self.down
    remove_column :admins, :blogger
  end
end
