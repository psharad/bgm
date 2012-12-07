class CreateTagLines < ActiveRecord::Migration
  def self.up
    create_table :tag_lines do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :tag_lines
  end
end
