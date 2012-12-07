class CreateBuilds < ActiveRecord::Migration
  def self.up
    create_table :builds do |t|
      t.string :text
      t.boolean :is_deleted, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :builds
  end
end
