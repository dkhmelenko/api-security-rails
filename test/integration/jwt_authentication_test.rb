require "test_helper"

class JwtAuthenticationTest < ActionDispatch::IntegrationTest
  setup do
    @headers = { "Accept" => "application/json", "Content-Type" => "application/json" }
  end

  test "sign up returns jwt in authorization header" do
    assert_difference("User.count", 1) do
      post user_registration_url,
           params: {
             user: {
               email: "newuser@example.test",
               password: "password123",
               password_confirmation: "password123",
               name: "New User"
             }
           },
           headers: @headers,
           as: :json
    end

    assert_response :success
    assert response.headers["Authorization"].to_s.start_with?("Bearer ")
  end

  test "sign in returns jwt in authorization header" do
    user = users(:one)

    post user_session_url,
         params: { user: { email: user.email, password: "password123" } },
         headers: @headers,
         as: :json

    assert_response :success
    assert response.headers["Authorization"].to_s.start_with?("Bearer ")
  end

  test "sign out revokes jwt" do
    user = users(:one)
    auth_headers = Devise::JWT::TestHelpers.auth_headers(@headers.dup, user)

    delete destroy_user_session_url, headers: auth_headers

    assert_response :no_content

    get users_url, headers: auth_headers
    assert_response :unauthorized
  end
end
