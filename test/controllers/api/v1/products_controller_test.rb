require "test_helper"

class Api::V1::ProductsControllerTest < ActionController::TestCase
  setup do
    @product = products(:one)
    @user = users(:one)
    @token = JsonWebToken.encode(user_id: @user.id)
    @request.headers['Authorization'] = "Bearer #{@token}"
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test 'should get show' do
    get :show, params: { id: @product.id }
    assert_response :success
    assert_equal @product.id, JSON.parse(@response.body)['id']
  end

  test 'should create product' do
    assert_difference('Product.count') do
      post :create, params: { product: { name: 'New Product', description: 'New Description', price: 20.0, storage_temperature: 'cold' } }
    end
    assert_response :created
  end

  test 'should update product' do
    patch :update, params: { id: @product.id, product: { name: 'Updated Product' } }
    assert_response :success
    assert_equal 'Updated Product', JSON.parse(@response.body)['name']
  end

  test 'should destroy product' do
    assert_difference('Product.count', -1) do
      delete :destroy, params: { id: @product.id }
    end
    assert_response :no_content
  end
end
