class AddPublishToImages < ActiveRecord::Migration
  def self.up
    add_column :images, :publish, :boolean, :default => false
  end

  def self.down
    remove_column :images, :publish
  end
end
