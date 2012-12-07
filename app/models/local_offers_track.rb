class LocalOffersTrack < ActiveRecord::Base
  belongs_to :local_offer

  searchable do
    time :created_at
    text :email do
      email.downcase
    end 
    text :local_offer do
      begin
        local_offer.title
      rescue
      end
    end    
  end
end
