class Api::V1::ProductsController < ApplicationController
    before_action :set_product, only: [ :show, :update, :destroy ]

    # GET /api/v1/products
    def index
      @products = current_user.organization.products
      render json: { products: @products }
    end

    # GET /api/v1/products/:id
    def show
      render json: @product
    end

    # POST /api/v1/products
    def create
      @product = current_user.organization.products.new(product_params)
      if @product.save
        render json: @product, status: :created
      else
        render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/products/:id
    def update
      if @product.update(product_params)
        render json: @product
      else
        render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/products/:id
    def destroy
      ActiveRecord::Base.transaction do
        @product.order_items.destroy_all
        @product.destroy
        head :no_content
      end
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    private

    def set_product
      @product = current_user.organization.products.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Product not found" }, status: :not_found
    end

    def product_params
      params.require(:product).permit(
        :name,
        :sku,
        :weight,
        :volume,
        :required_temperature,
        :organization_id,
        :storage_temperature
      )
    end
end
