class PostsController < ApplicationController
  skip_before_filter :check_private_beta
  def index
    if current_admin.blogger == true
      @posts = Post.find(:all, :conditions => {:blogger_id => current_admin.id}, :order => "created_at DESC")
      @draft = Post.find(:all, :conditions => {:blogger_id => current_admin.id, :draft => true}, :order => "created_at DESC")
      @published = Post.find(:all, :conditions => {:blogger_id => current_admin.id, :draft => false}, :order => "created_at DESC")
    else  
      @posts = Post.find(:all, :order => "created_at DESC")
      @draft = Post.find(:all, :conditions => {:draft => true}, :order => "created_at DESC")
      @published = Post.find(:all, :conditions => {:draft => false}, :order => "created_at DESC")
    end
    @posts = @posts.paginate(:page => params[:post_page], :per_page => 20)
    @draft = @draft.paginate(:page => params[:draft], :per_page => 8)
    @published = @published.paginate(:page => params[:published], :per_page => 8)
    
    render :layout => 'admin'
  end

  def show
    #debugger
    #@post = Post.find(params[:id])
    #render :layout => false
    
    if mobile_device?
      @post = Post.find(params[:id])
      @posts = Post.find_all_by_blogger_id(@post.blogger_id)
      @published = Post.find(:all, :conditions => {:blogger_id => @post.blogger_id, :draft => false}, :order => "created_at DESC")
      render :layout => 'blog'
    end

  end

  def new
    @post = Post.new
  end

  def create
    if (params[:post][:post_slug].blank?)
      params[:post][:post_slug] = params[:post][:title]
    end
    @post = Post.new(params[:post])
    if @post.save
      # flash[:notice] = "Successfully created post."
      if params[:save_button]
        @post.update_attributes(:draft => true)
        # flash[:notice] = "Saved Changes!"
        if params[:post][:image].blank?
          redirect_to edit_post_url(@post)
        else
          render :action => "save_crop"
        end
      else
        @post.update_attributes(:draft => false, :published_at => Time.now, :publish => true)
        @admin = Admin.find(@post.blogger_id)
        description = @admin.name + ' has created ' + @post.title + ' post.'
        Dashboard.create(:description => description, :post_id => @post.id, :blogger_id => current_admin.id)
        
        if params[:post][:image].blank?
          redirect_to posts_url
        else
          render :action => "crop"
        end
      end
    else
      render :action => 'new'
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      # flash[:notice] = "Successfully updated post."
      # redirect_to @post
      if params[:save_button]
        @post.update_attributes(:draft => true)
        # flash[:notice] = "Save to Draft!"
        if params[:post][:image].blank?
          redirect_to edit_post_url(@post)
        else
          render :action => "save_crop"
        end
      else
        @post.update_attributes(:draft => false, :published_at => Time.now, :publish => true)
        @admin = Admin.find(@post.blogger_id)
        if @post.publish == true
          description = @admin.name + ' has updated ' + @post.title + ' post.'
        else
          description = @admin.name + ' has created ' + @post.title + ' post.'
        end
        Dashboard.create(:description => description, :post_id => @post.id, :blogger_id => current_admin.id)
        if params[:post][:image].blank?
          redirect_to posts_url
        else
          render :action => "crop"
        end
      end
    else
      render :action => 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @admin = Admin.find(@post.blogger_id)
    if current_admin.username == 'admin'
      description = 'Admin has deleted ' + @post.title
    else
      description = @admin.name + ' has deleted ' + @post.title + ' post.'
    end
    Dashboard.create(:description => description, :post_id => @post.id, :deleted => true)
    Dashboard.update_all({:deleted => true}, {:post_id => @post.id})
    @post.destroy
    # flash[:notice] = "Successfully destroyed post."
    redirect_to posts_url
  end
  
  def main
    @post = Post.find(params[:id])
    @posts = Post.find_all_by_blogger_id(@post.blogger_id)
    @published = Post.find(:all, :conditions => {:blogger_id => @post.blogger_id, :draft => false}, :order => "created_at DESC")
    #render :layout => false
  end
  
  def draft
    if current_admin.blogger == true
      @draft = Post.find(:all, :conditions => {:blogger_id => current_admin.id, :draft => true}, :order => "created_at DESC")
    else  
      @draft = Post.find(:all, :conditions => {:draft => true}, :order => "created_at DESC")
    end
    @draft = @draft.paginate(:page => params[:page], :per_page => 10)
    @admin = Admin.all
  end
  
  def save_image
    redirect_to edit_post_url(@post)
  end
  
  def load
    @bloggers = Admin.find(:all, :conditions => {:blogger => true}, :limit  => 4, :offset => params[:offset]).reverse

    respond_to do |format|
      format.js 
    end
  end
  
end
