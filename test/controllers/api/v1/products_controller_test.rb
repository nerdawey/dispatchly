require "test_helper"

class Api::V1::ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = organizations(:one)
    @product = products(:one)
    @user = users(:one)  # Using org_admin user from organization one
    @headers = setup_auth_headers(@user)
    setup_ability(@user)

    # Ensure product belongs to the same organization as the user
    @product.update!(organization_id: @organization.id)

    if Rails.env.test?
      puts "[TEST DEBUG] User Org ID: #{@user.organization_id}, Product Org ID: #{@product.organization_id}"
    end
  end

  test "should get index" do
    get "/api/v1/products", headers: @headers
    assert_response :success
    assert_not_nil JSON.parse(@response.body)["products"]
  end

  test "should only show products from user's organization" do
    other_product = products(:two) # belongs to a different organization
    get "/api/v1/products", headers: @headers
    product_ids = JSON.parse(@response.body)["products"].map { |p| p["id"] }
    assert_includes product_ids, @product.id
    assert_not_includes product_ids, other_product.id
  end

  test "should get show" do
    get "/api/v1/products/#{@product.id}", headers: @headers
    assert_response :success
    assert_equal @product.id, JSON.parse(@response.body)["id"]
  end

  test "should create product" do
    assert_difference("Product.count") do
      post "/api/v1/products", headers: @headers, params: {
        product: {
          name: "New Product",
          sku: "NEW-001",
          weight: 1.5,
          volume: 2.0,
          required_temperature: 4.0,
          storage_temperature: "chilled"
        }
      }
    end
    assert_response :created
    response_data = JSON.parse(@response.body)
    assert_equal "New Product", response_data["name"]
    assert_equal "NEW-001", response_data["sku"]
    assert_equal @user.organization_id, response_data["organization_id"]
  end

  test "should update product" do
    patch "/api/v1/products/#{@product.id}", headers: @headers, params: {
      product: { name: "Updated Product" }
    }
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_equal "Updated Product", response_data["name"]
    @product.reload
    assert_equal "Updated Product", @product.name
  end

  test "should destroy product" do
    assert_difference("Product.count", -1) do
      delete "/api/v1/products/#{@product.id}", headers: @headers
    end
    assert_response :no_content
    assert_raises(ActiveRecord::RecordNotFound) do
      @product.reload
    end
  end
end
