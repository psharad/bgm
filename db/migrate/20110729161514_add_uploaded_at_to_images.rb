class AddUploadedAtToImages < ActiveRecord::Migration
  def self.up
    add_column :images, :uploaded_at, :datetime
  end

  def self.down
    remove_column :images, :uploaded_at
  end
end
