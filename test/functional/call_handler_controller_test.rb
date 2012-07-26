require 'test_helper'

class CallHandlerControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get record_message" do
    get :record_message
    assert_response :success
  end

end
