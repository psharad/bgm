class CreateBetaKey < ActiveRecord::Migration
  def self.up
    create_table :beta_keys do |t|
      t.string  :beta_key
    end
  end

  def self.down
    drop_table :beta_key
  end
end
