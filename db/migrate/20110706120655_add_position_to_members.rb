class AddPositionToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :position, :integer, :default => 1
    
    Group.all.each do |g|
      g.members.each_with_index do |m, i|
        m.update_attribute(:position, i+1)
      end
    end
  end

  def self.down
    remove_column :members, :position
  end
end
