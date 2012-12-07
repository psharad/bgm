class SearchController < ApplicationController
  before_filter :logged_in
  before_filter :search_group_owner
  
  def index
    main_page_cred
    search   = params[:search]
    @results = []

    if search
      search.delete_if {|n,v| v.blank? }
    else
      search = []
    end

    if search
      @results = Search.group(search)
      @results = @results.paginate(:page => params[:page], :per_page => 5)
    end
  end
  
  def search_group_owner
    main_page_cred
    unless current_user.groups
      redirect_to root_url
    end
  end
end
