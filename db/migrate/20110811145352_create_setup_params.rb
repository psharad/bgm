class CreateSetupParams < ActiveRecord::Migration
  def self.up
    create_table :setup_params do |t|
      t.text :group
      t.text :user
      t.text :members
      t.timestamps
    end
  end

  def self.down
    drop_table :setup_params
  end
end
