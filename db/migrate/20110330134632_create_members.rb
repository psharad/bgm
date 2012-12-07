class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.string :email
      t.string :sex
      t.integer :age
      t.integer :height_id
      t.integer :build_id
      t.integer :ethnicity_id
      t.integer :language_id
      t.integer :education_id
      t.integer :university_id
      t.integer :occupation_id

      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end
