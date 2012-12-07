class AddDraftToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :draft, :boolean, :default => false
  end

  def self.down
    remove_column :posts, :draft
  end
end
