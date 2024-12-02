class HomeController < ApplicationController
  layout "frontend"
  
  def index
    @products = Product.all  # Fetch all products
  end
end
