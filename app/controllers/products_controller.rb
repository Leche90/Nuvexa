class ProductsController < ApplicationController
  layout "frontend"
  def index
    @products = Product.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @product = Product.find(params[:id])

    # Fetch related products that share at least one category with the current product
    @related_products = Product.joins(:categories)
                               .where(categories: { id: @product.category_ids })
                               .where.not(id: @product.id)  # Exclude the current product
                               .distinct  # Avoid duplicates
                               .limit(4)  # Limit the number of related products displayed
  end
end
