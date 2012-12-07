class CreateTweetDatas < ActiveRecord::Migration
  def self.up
    create_table :tweet_datas do |t|
      t.text :tdata
      
      t.timestamps
    end
  end

  def self.down
    drop_table :tweet_datas
  end
end
