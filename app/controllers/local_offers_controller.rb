class LocalOffersController < ApplicationController
  skip_before_filter :check_private_beta
  # GET /local_offers
  # GET /local_offers.xml
  def index
    @local_offers = LocalOffer.all    
    @local_offers = @local_offers.paginate(:page => params[:page], :per_page => 10)

    render :layout => 'admin'
  end

  # GET /local_offers/1
  # GET /local_offers/1.xml
  def show
    @local_offer = LocalOffer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @local_offer }
    end
  end

  # GET /local_offers/new
  # GET /local_offers/new.xml
  def new
    @local_offer = LocalOffer.new

    render :layout => 'admin'
  end

  # GET /local_offers/1/edit
  def edit
    @local_offer = LocalOffer.find(params[:id])
  end

  # POST /local_offers
  # POST /local_offers.xml
  def create
    @local_offer = LocalOffer.new(params[:local_offer])
    if @local_offer.save
      # flash[:notice] = "Successfully created post."
      if params[:save_button]
        # @post.update_attributes(:draft => true)
        # flash[:notice] = "Saved Changes!"
        if params[:local_offer][:image].blank?
          redirect_to edit_local_offer_url(@local_offer)
        else
          render :action => "save_crop"
        end
      else
        # @post.update_attributes(:draft => false, :published_at => Time.now, :publish => true)
        # @admin = Admin.find(@post.blogger_id)
        # description = @admin.name + ' has created ' + @post.title + ' post.'
        # Dashboard.create(:description => description, :post_id => @post.id, :blogger_id => current_admin.id)
        
        if params[:local_offer][:image].blank?
          redirect_to local_offers_url
        else
          render :action => "crop"
        end
      end
    else
      render :action => 'new'
    end
  end

  # PUT /local_offers/1
  # PUT /local_offers/1.xml
  def update
    # @local_offer = LocalOffer.find(params[:id])
    # 
    # respond_to do |format|
    #   if @local_offer.update_attributes(params[:local_offer])
    #     format.html { redirect_to(@local_offer, :notice => 'LocalOffer was successfully updated.') }
    #     format.xml  { head :ok }
    #   else
    #     format.html { render :action => "edit" }
    #     format.xml  { render :xml => @local_offer.errors, :status => :unprocessable_entity }
    #   end
    # end
    
    @local_offer = LocalOffer.find(params[:id])
    if @local_offer.update_attributes(params[:local_offer])
      # flash[:notice] = "Successfully updated post."
      # redirect_to @post
      if params[:save_button]
        # flash[:notice] = "Save to Draft!"
        if params[:local_offer][:image].blank?
          redirect_to edit_local_offer_url(@local_offer)
        else
          render :action => "save_crop"
        end
      else
        # @local_offer.update_attributes(:draft => false, :published_at => Time.now, :publish => true)
        # @admin = Admin.find(@post.blogger_id)
        # if @post.publish == true
        #   description = @admin.name + ' has updated ' + @post.title + ' post.'
        # else
        #   description = @admin.name + ' has created ' + @post.title + ' post.'
        # end
        # Dashboard.create(:description => description, :post_id => @post.id, :blogger_id => current_admin.id)
        if params[:local_offer][:image].blank?
          redirect_to local_offers_url
        else
          render :action => "crop"
        end
      end
    else
      render :action => 'edit'
    end
  end
  

  # DELETE /local_offers/1
  # DELETE /local_offers/1.xml
  def destroy
    @local_offer = LocalOffer.find(params[:id])
    @local_offer.destroy

    respond_to do |format|
      format.html { redirect_to(local_offers_url) }
      format.xml  { head :ok }
    end
  end
  
  def load
    @local_offers = LocalOffer.find(:all).paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.js 
    end
  end

  def send_local_offer
    #debugger
    local_offer = LocalOffer.find(params[:local_offer_id])
    Emailer.deliver_local_offer(params[:email], local_offer)

    LocalOffersTrack.create(
      :local_offer_id => params[:local_offer_id],
      :email => params[:email]
    ) 
  
    render :text => true
  end

  def main
    @local_offer  = LocalOffer.find(params[:id])
    @local_offers = LocalOffer.find(:all)
    render :layout => false
  end

end
