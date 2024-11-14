class OrdersController < ApplicationController
  layout "frontend"
  before_action :authenticate_frontend_user!, only: [ :new, :create, :show ]
  before_action :set_order, only: [ :show ]
  def new
  end

  def create
  end

  def show
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end
