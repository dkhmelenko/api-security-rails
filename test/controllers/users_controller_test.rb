require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @other = users(:two)
    @headers = { "Accept" => "application/json", "Content-Type" => "application/json" }
    @auth_headers = Devise::JWT::TestHelpers.auth_headers(@headers.dup, @user)
  end

  test "should reject unauthenticated index" do
    get users_url, headers: @headers
    assert_response :unauthorized
  end

  test "should get index when authenticated" do
    get users_url, headers: @auth_headers
    assert_response :success
  end

  test "should show user when authenticated as self" do
    get user_url(@user), headers: @auth_headers
    assert_response :success
  end

  test "should forbid showing another user" do
    get user_url(@other), headers: @auth_headers
    assert_response :forbidden
  end

  test "should update user when authenticated as self" do
    patch user_url(@user),
          params: { user: { email: @user.email, name: "Updated" } },
          headers: @auth_headers,
          as: :json
    assert_response :success
  end

  test "should forbid updating another user" do
    patch user_url(@other),
          params: { user: { email: @other.email, name: "Hacked" } },
          headers: @auth_headers,
          as: :json
    assert_response :forbidden
  end

  test "should destroy user when authenticated as self" do
    deletable = User.create!(
      email: "deletable@example.test",
      password: "password123",
      password_confirmation: "password123",
      name: "Deletable"
    )
    headers = Devise::JWT::TestHelpers.auth_headers(@headers.dup, deletable)

    assert_difference("User.count", -1) do
      delete user_url(deletable), headers: headers
    end

    assert_response :no_content
  end

  test "should forbid destroying another user" do
    assert_no_difference("User.count") do
      delete user_url(@other), headers: @auth_headers
    end

    assert_response :forbidden
  end
end
