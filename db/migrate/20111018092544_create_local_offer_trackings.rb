class CreateLocalOfferTrackings < ActiveRecord::Migration
  def self.up
    create_table :local_offers_tracks do |t|
      t.integer :local_offer_id
      t.string :email
      t.timestamps
    end
  end

  def self.down
    drop_table :local_offers_tracks
  end
end
