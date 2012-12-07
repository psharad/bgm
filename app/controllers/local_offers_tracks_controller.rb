class LocalOffersTracksController < ApplicationController
  skip_before_filter :check_private_beta
  
  def index
    #@search = LocalOffersTrack.search(params[:search])
    if params[:search]
      @results = Search.local_offers_track_search(params[:search], params[:page])
    else
      @results = LocalOffersTrack.search do
        paginate(:page => params[:page], :per_page => 10)
      end.results
    end
    #@local_offers_tracks = @search.all
    render :layout => 'admin'
  end
end
