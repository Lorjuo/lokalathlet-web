require "test_helper"

describe EventsController do

  let(:eventname) { events :one }

  it "gets index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:events)
  end

  it "gets new" do
    get :new
    assert_response :success
  end

  it "creates event" do
    assert_difference('Event.count') do
      post :create, eventname: {name: @event.name, team_size: @event.team_size }
    end

    assert_redirected_to event_path(assigns(:eventname))
  end

  it "shows event" do
    get :show, id: eventname
    assert_response :success
  end

  it "gets edit" do
    get :edit, id: eventname
    assert_response :success
  end

  it "updates event" do
    put :update, id: eventname, eventname: {name: @event.name, team_size: @event.team_size }
    assert_redirected_to event_path(assigns(:eventname))
  end

  it "destroys event" do
    assert_difference('Event.count', -1) do
      delete :destroy, id: eventname
    end

    assert_redirected_to events_path
  end

end
