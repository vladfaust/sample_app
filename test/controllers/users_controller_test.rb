require 'test_helper.rb.rb'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = users(:michael)
    @another_user = users(:archer)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should redirect edit when not logged in' do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect update when not logged in' do
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect edit when wrong user' do
    log_in_as(@another_user)
    get :edit, id: @user
    assert_redirected_to root_url
  end

  test 'should redirect update when wrong user' do
    log_in_as(@another_user)
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert_redirected_to root_url
  end

  test 'should redirect from index when not logged in' do
    get :index
    assert_redirected_to login_url
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end

  test 'should redirect destroy when not admin' do
    log_in_as(@another_user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end

  test 'should not alow the admin attribute edited through the web' do
    log_in_as(@another_user)
    assert_not @another_user.admin?
    patch :update, id: @another_user, user: { password: 'password',
                                              password_confirmation: 'password',
                                              admin: true }
    assert_not @another_user.reload.admin?
  end
end
