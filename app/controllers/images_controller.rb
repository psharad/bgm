class ImagesController < ApplicationController
  skip_before_filter :check_private_beta
  def index
    if current_admin.blogger == true
      @images = Image.find_by_blogger_id(current_admin.id, :order => "created_at DESC")
    else
      @images = Image.find(:all, :order => "created_at DESC")
    end
    @images = @images.paginate(:page => params[:page], :per_page => 9)
    
    render :layout => 'admin'
  end

  def show
    @image = Image.find(params[:id])
  end

  def new
    @image = Image.new
  end

  def create
    @image = Image.new(params[:image])
    if @image.save
      # flash[:notice] = "Successfully uploaded image."
      @image.update_attributes(:uploaded_at => Time.now, :publish => true)
      description = 'Admin has uploaded ' + @image.image_file_name + '.'
      Dashboard.create(:description => description, :image_id => @image.id)
      if params[:image][:image].blank?
        redirect_to @image
      else  
        render :action => 'crop'
      end
    else
      render :action => 'new'
    end
  end

  def edit
    @image = Image.find(params[:id])
    # render :action => 'edit_crop'
  end

  def update
    @image = Image.find(params[:id])
    if @image.update_attributes(params[:image])
      # flash[:notice] = "Successfully updated image."
      if params[:edit_button]
        description = 'Admin has edited ' + @image.image_file_name + '.'
        Dashboard.create(:description => description, :image_id => @image.id)
      end
      if params[:image][:image].blank?
        redirect_to @image
      else  
        render :action => 'edit_crop'
      end
    else
      render :action => 'edit'
    end
  end

  def destroy
    @image = Image.find(params[:id])
    description = 'Admin has deleted ' + @image.image_file_name + '.'
    Dashboard.create(:description => description, :image_id => @image.id, :deleted => true)
    Dashboard.update_all({:deleted => true}, {:image_id => @image.id})
    @image.destroy
    # flash[:notice] = "Successfully destroyed image."
    redirect_to images_url
  end
end
