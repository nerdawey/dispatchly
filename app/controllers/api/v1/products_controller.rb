class Api::V1::ProductsController < ApplicationController
    before_action :set_product, only: [ :show, :update, :destroy ]

    # GET /api/v1/products
    def index
      if current_user.super_admin?
        @products = Product.all
      else
        @products = current_user.organization.products
      end
      if Rails.env.test?
        Rails.logger.debug { "[CONTROLLER DEBUG] index - current_user: #{current_user.id}, org_id: #{current_user.organization_id}" }
      end
      authorize! :read, Product
      render json: { products: @products.as_json(include: { organization: { only: [:id, :name] } }) }
    end

    # GET /api/v1/products/:id
    def show
      if Rails.env.test?
        Rails.logger.debug { "[CONTROLLER DEBUG] show - current_user: #{current_user.id}, org_id: #{current_user.organization_id}, product: #{@product.id}, product_org_id: #{@product.organization_id}" }
      end
      authorize! :read, @product
      render json: @product
    end

    # POST /api/v1/products
    def create
      authorize! :create, Product
      if current_user.super_admin?
        @product = Product.new(product_params)
        unless @product.organization_id.present?
          return render json: { errors: ["Organization is required for super admin"] }, status: :unprocessable_entity
        end
      else
      @product = current_user.organization.products.new(product_params)
      end
      if Rails.env.test?
        Rails.logger.debug { "[CONTROLLER DEBUG] create - current_user: #{current_user.id}, org_id: #{current_user.organization_id}, product_org_id: #{@product.organization_id}" }
      end
      if @product.save
        render json: @product, status: :created
      else
        render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/products/:id
    def update
      if Rails.env.test?
        Rails.logger.debug { "[CONTROLLER DEBUG] update - current_user: #{current_user.id}, org_id: #{current_user.organization_id}, product: #{@product.id}, product_org_id: #{@product.organization_id}" }
      end
      authorize! :update, @product
      if @product.update(product_params)
        render json: @product
      else
        render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/products/:id
    def destroy
      if Rails.env.test?
        Rails.logger.debug { "[CONTROLLER DEBUG] destroy - current_user: #{current_user.id}, org_id: #{current_user.organization_id}, product: #{@product.id}, product_org_id: #{@product.organization_id}" }
      end
      authorize! :destroy, @product
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
      if current_user.super_admin?
        params.require(:product).permit(
          :sku,
          :weight,
          :storage_temperature,
          :required_temperature,
          :length,
          :width,
          :height,
          :number_of_boxes,
          :organization_id
        )
      else
        params.require(:product).permit(
          :sku,
          :weight,
          :storage_temperature,
          :required_temperature,
          :length,
          :width,
          :height,
          :number_of_boxes
      )
      end
    end
end
