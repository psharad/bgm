class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string  :name
      t.integer :state_id
      t.string  :zip
      t.string  :gender
      t.integer :size
      t.integer :match_preference
      t.integer :user_id
      t.datetime :expiration_date
      t.timestamps
    end
  end

  def self.down
    drop_table :groups
  end
end
