class BuiltsController < ApplicationController
  # GET /builts
  # GET /builts.xml
  def index
    @builts = Built.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @builts }
    end
  end

  # GET /builts/1
  # GET /builts/1.xml
  def show
    @built = Built.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @built }
    end
  end

  # GET /builts/new
  # GET /builts/new.xml
  def new
    @built = Built.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @built }
    end
  end

  # GET /builts/1/edit
  def edit
    @built = Built.find(params[:id])
  end

  # POST /builts
  # POST /builts.xml
  def create
    @built = Built.new(params[:built])

    respond_to do |format|
      if @built.save
        format.html { redirect_to(@built, :notice => 'Built was successfully created.') }
        format.xml  { render :xml => @built, :status => :created, :location => @built }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @built.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /builts/1
  # PUT /builts/1.xml
  def update
    @built = Built.find(params[:id])

    respond_to do |format|
      if @built.update_attributes(params[:built])
        format.html { redirect_to(@built, :notice => 'Build was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @built.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /builts/1
  # DELETE /builts/1.xml
  def destroy
    @built = Built.find(params[:id])
    @built.destroy

    respond_to do |format|
      format.html { redirect_to(builts_url) }
      format.xml  { head :ok }
    end
  end
end
