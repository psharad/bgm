class CreatePreferences < ActiveRecord::Migration
  def self.up
    create_table :preferences do |t|
      t.integer  :interest_id
      t.integer  :day_id
      t.integer  :availability_id
      t.string  :description

      t.timestamps
    end
  end

  def self.down
    drop_table :preferences
  end
end
