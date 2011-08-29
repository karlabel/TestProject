class CartsController < ApplicationController
  skip_before_filter :authorize, :only => [:create, :update, :destroy]
  
  # GET /carts
  # GET /carts.xml
  def index
    @carts = Cart.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @carts }
    end
  end

  # GET /carts/1
  # GET /carts/1.xml
  def show
    begin
      @cart = Cart.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error "Attempt to access invalid cart #{params[:id]}"
      redirect_to store_url, :notice => 'Invalid cart'
    else
      if check_session
        respond_to do |format|
          format.html # show.html.erb
          format.xml  { render :xml => @cart.to_xml(:include => [:line_items]) }
        end
      end
    end
  end

  # GET /carts/new
  # GET /carts/new.xml
  def new
    @cart = Cart.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cart }
    end
  end

  # GET /carts/1/edit
  def edit
    @cart = Cart.find(params[:id])
    check_session
  end

  # POST /carts
  # POST /carts.xml
  def create
    @cart = Cart.new(params[:cart])

    respond_to do |format|
      if @cart.save
        format.html { redirect_to(@cart, :notice => 'Cart was successfully created.') }
        format.xml  { render :xml => @cart, :status => :created, :location => @cart }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cart.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /carts/1
  # PUT /carts/1.xml
  def update
    @cart = Cart.find(params[:id])
    if check_session
      respond_to do |format|
        if @cart.update_attributes(params[:cart])
          format.html { redirect_to(@cart, :notice => 'Cart was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @cart.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.xml
  def destroy
    @cart = current_cart
    if check_session
      @cart.destroy
      session[:cart_id] = nil

      respond_to do |format|
        format.html { redirect_to(store_url) }
        format.js
        format.xml  { head :ok }
      end
    end
  end
  
  def remove_from_cart(item)
    begin
      product = Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to store_url
    else
      @cart = find_cart
      @current_item = @cart.remove_product(product)
      respond_to do |format|
        format.html { redirect_to store_url }
        format.js
      end
    end
  end
  
  def check_session
    if @cart.id != session[:cart_id]
      respond_to do |format|
        format.html { redirect_to store_url }
        format.xml { render :xml => nil }
      end
      return false
    end
    true
  end

end