class CreateEthnicities < ActiveRecord::Migration
  def self.up
    create_table :ethnicities do |t|
      t.string :text
      t.boolean :is_deleted, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :ethnicities
  end
end
