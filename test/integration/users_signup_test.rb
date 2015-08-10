require 'test_helper.rb.rb'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test 'invalid signup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: {  name: '',
                                email: 'user@invalid',
                                password: 'foo',
                                password_confirmation: 'bar'  }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger.alert'
  end

  test 'valid signup information' do
    get signup_path

    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: {   name: 'Example User',
                                              email: 'user@example.com',
                                              password: 'password',
                                              password_confirmation: 'password' }
    end

    assert_template 'users/show'
    assert_not flash.nil?
    assert is_logged_in?

    delete logout_path
    follow_redirect!

    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
  end
end
