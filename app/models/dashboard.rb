class Dashboard < ActiveRecord::Base
  attr_accessible :description, :post_id, :image_id, :blogger_id, :deleted
end
