class CheckoutsController < ApplicationController
  before_action :authenticate_frontend_user!
  before_action :set_user
  before_action :set_cart_items, only: [ :index, :create ]
  before_action :set_provinces, only: [ :index ]
  layout "frontend"

  def index
    Rails.logger.debug "User ID: #{@user.id}"
    if @user.address
      Rails.logger.debug "User's Address: #{@user.address.attributes}"
    else
      Rails.logger.debug "User has no address."
    end

    @order = @user.orders.build

    # Log the new order object before we start associating it
    Rails.logger.debug "New Order before associations: #{@order.attributes}"

    if @user.address
      # Associate the order with the user's existing address via the address association
      @order.address = @user.address
      Rails.logger.debug "Order associated with existing address: #{@order.address.attributes}"
    else
      # If no address exists for the user, create a new address object
      @order.build_address
      Rails.logger.debug "Order has new empty address: #{@order.address.attributes}"
    end

    # Log the final order object after building or associating the address
    Rails.logger.debug "Order after address association: #{@order.attributes}"

    calculate_totals
  end








  def create
    if @cart_items.empty?
      redirect_to cart_index_path, alert: "Your cart is empty."
      return
    end

    unless @user.address || address_params[:province_id].present?
      flash.now[:alert] = "Please provide your address or at least your province."
      render :index
      return
    end

    # Pass address attributes correctly when creating the order
    @order = @user.orders.build(total_price: @total_price, total_tax: @total_tax, address_attributes: address_params)

    @cart_items.each do |item|
      @order.order_items.build(product: item[:product], quantity: item[:quantity], price: item[:product].price)
    end

    if @order.save
      session[:cart] = {}
      redirect_to order_path(@order), notice: "Checkout complete! Your order has been placed."
    else
      flash[:alert] = "There was an issue processing your order."
      render :index
    end
  end


  private

  def set_user
    @user = current_frontend_user
  end

  def set_cart_items
    @cart = session[:cart] || {}
    @cart_items = Product.find(@cart.keys.map(&:to_i)).map do |product|
      { product: product, quantity: @cart[product.id.to_s].to_i }
    end
  end

  def set_provinces
    @provinces = Province.all
  end

  def calculate_totals
    # Calculate subtotal
    @subtotal = @cart_items.sum { |item| item[:product].price * item[:quantity] }

    # Apply taxes based on province
    @province = @user.address&.province || Province.find_by(id: address_params[:province_id])
    if @province
      @gst = @subtotal * @province.gst
      @pst = @subtotal * @province.pst
      @hst = @subtotal * @province.hst
    else
      @gst = @pst = @hst = 0
    end

    @total_tax = @gst + @pst + @hst
    @total_price = @subtotal + @total_tax
  end

  def address_params
    params.require(:address).permit(:address_line1, :address_line2, :city, :province_id, :postal_code, :country)
  end
end
