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
          sku: "NEW-001",
          weight: 1.5,
          required_temperature: -18.0,
          storage_temperature: "frozen",
          organization_id: @user.organization_id,
          number_of_boxes: 100
        }
      }
    end
    assert_response :created
    response_data = JSON.parse(@response.body)
    assert_equal "NEW-001", response_data["sku"]
    assert_equal @user.organization_id, response_data["organization_id"]
    assert_equal -18.0, response_data["required_temperature"]
    assert_equal "frozen", response_data["storage_temperature"]
  end

  test "should update product" do
    patch "/api/v1/products/#{@product.id}", headers: @headers, params: {
      product: {
        sku: "UPD-001",
        required_temperature: -18.0,
        storage_temperature: "frozen"
      }
    }
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_equal "UPD-001", response_data["sku"]
    assert_equal -18.0, response_data["required_temperature"]
    assert_equal "frozen", response_data["storage_temperature"]
    @product.reload
    assert_equal "UPD-001", @product.sku
    assert_equal -18.0, @product.required_temperature
    assert_equal "frozen", @product.storage_temperature
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
