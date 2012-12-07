class AddAdminFieldsToCities < ActiveRecord::Migration
  def self.up
    add_column :cities, :is_displayed, :boolean, :default => false
    add_column :cities, :is_active, :boolean, :default => true
    add_column :cities, :sort_id, :integer
    
    City.update_all(:is_displayed => false, :is_active => true)
    City.all.each_with_index do |city, index|
      city.update_attribute(:sort_id, index)
    end
  end

  def self.down
    remove_column :cities, :is_active
    remove_column :cities, :is_displayed
    remove_column :cities, :sort_id
  end
end
