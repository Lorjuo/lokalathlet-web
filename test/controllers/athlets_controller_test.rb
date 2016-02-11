require 'test_helper'

class AthletsControllerTest < ActionController::TestCase
  setup do
    @athlet = athlets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:athlets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create athlet" do
    assert_difference('Athlet.count') do
      post :create, athlet: {birthday: @athlet.birthday, club: @athlet.club, eventname: @athlet.eventname, firstname: @athlet.firstname, relaystarter: @athlet.relaystarter, relaytm: @athlet.relaytm, sex: @athlet.sex, starter: @athlet.starter, surname: @athlet.surname,
                             transponderid: @athlet.transponderid }
    end

    assert_redirected_to athlet_path(assigns(:athlet))
  end

  test "should show athlet" do
    get :show, id: @athlet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @athlet
    assert_response :success
  end

  test "should update athlet" do
    patch :update, id: @athlet, athlet: {birthday: @athlet.birthday, club: @athlet.club, eventname: @athlet.eventname, firstname: @athlet.firstname, relaystarter: @athlet.relaystarter, relaytm: @athlet.relaytm, sex: @athlet.sex, starter: @athlet.starter, surname: @athlet.surname,
                                         transponderid: @athlet.transponderid }
    assert_redirected_to athlet_path(assigns(:athlet))
  end

  test "should destroy athlet" do
    assert_difference('Athlet.count', -1) do
      delete :destroy, id: @athlet
    end

    assert_redirected_to athlets_path
  end
end
