class Search
  def self.group(query={})
    Group.search do
      if query
        query.delete_if {|k,v| v.blank?}
        query.each do |k,v|
          with k, v
        end
      end

      # if order == "city"
      #   order_by :city_id, :asc
      # end
      # if order == "zip"
      #   order_by :zip, :asc
      # end
      # if order == "sex"
      #   order_by :gender, :asc
      # end
      # if order == "members"
      #   order_by :size, :asc
      # end
      order_by :expiration_date, :desc
      # with(:expiration_date).greater_than(Time.now)
      with :is_deactivated, false
      # paginate :page => page, :per_page => 5
    end.results
  end

  def self.local_offers_track_search(param, page)
    LocalOffersTrack.search do
      keywords param[:local_offer_like], :minimum_match => 2
      paginate :page => page, :per_page => 10
    end.results
  end
end
