class AddRollbackTokenToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :rollback_token, :string
    
    User.all.each do |u|
      u.update_attribute(:rollback_token, Digest::SHA1.hexdigest([u.created_at, u.id].join))
    end
    
    add_index :users, [:rollback_token]
  end

  def self.down
    remove_column :users, :rollback_token
  end
end
