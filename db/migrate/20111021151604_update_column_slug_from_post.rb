class UpdateColumnSlugFromPost < ActiveRecord::Migration
  def self.up
    remove_column :posts, :slug
    add_column :posts, :post_slug, :string
  end

  def self.down
    add_column :posts, :slug, :string
    remove_column :posts, :post_slug
  end
end
