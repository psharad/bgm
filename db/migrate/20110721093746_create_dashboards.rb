class CreateDashboards < ActiveRecord::Migration
  def self.up
    create_table :dashboards do |t|
      t.string  :description
      t.integer :post_id
      t.integer :image_id
      t.integer :blogger_id
      t.timestamps
    end
  end

  def self.down
    drop_table :dashboards
  end
end
