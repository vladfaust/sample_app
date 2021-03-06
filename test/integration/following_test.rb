require 'test_helper.rb.rb'

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @another_user = users(:archer)
    log_in_as @user
  end

  test 'following page' do
    get following_user_path(@user)
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    @user.following.each { |user| assert_select 'a[href=?]', user_path(user) }
  end

  test 'followers page' do
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each { |user| assert_select 'a[href=?]', user_path(user) }
  end

  test 'should follow a user the standard way' do
    assert_difference '@user.following.count', 1 do
      post relationships_path, followed_id: @another_user.id
    end
  end

  test 'should follow a user with Ajax' do
    assert_difference '@user.following.count', 1 do
      xhr :post, relationships_path, followed_id: @another_user.id
    end
  end

  test 'should unfollow a user the standard way' do
    @user.follow(@another_user)
    relationship = @user.active_relationships.find_by(followed_id: @another_user.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test 'should unfollow a user with Ajax' do
    @user.follow(@another_user)
    relationship = @user.active_relationships.find_by(followed_id: @another_user.id)
    assert_difference '@user.following.count', -1 do
      xhr :delete, relationship_path(relationship)
    end
  end
end
