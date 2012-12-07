class CreateLocalOffers < ActiveRecord::Migration
  def self.up
    create_table :local_offers do |t|
      t.string :title
      t.string :description
      t.integer :admin_id

      t.timestamps
    end
  end

  def self.down
    drop_table :local_offers
  end
end
