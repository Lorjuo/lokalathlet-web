require "test_helper"

describe Event do
  let(:eventname) { Event.new }

  it "must be valid" do
    eventname.must_be :valid?
  end
end
