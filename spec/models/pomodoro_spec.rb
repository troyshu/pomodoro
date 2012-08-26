require 'spec_helper'

describe Pomodoro do
  let(:user) { FactoryGirl.create(:user) }
  before do
  	#we can do this because a user has many pomodoros
    @pomodoro = user.pomodoros.new(finished: true, length: 25)
	  
  end

  

  subject { @pomodoro }

  it { should respond_to(:finished) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user)}
  it { should respond_to(:length) }

  its(:user) { should == user }
  its(:length) { should == 25 }

  describe "when user id is not present" do
  	before { @pomodoro.user_id = nil }
  	it { should_not be_valid }
  end



  describe "default length for unfinished one" do
    before { @unfinished_pomodoro = user.pomodoros.new(finished: false) }
  	subject { @unfinished_pomodoro }
    its(:length) { should == 0 }
  end

  describe "length should never be negative" do
    before { @pomodoro.length = -1 }
    it { should_not be_valid }
  end

  describe "accessible attributes" do
	it "should not allow access to user id" do
		expect do
			Pomodoro.new(user_id: user.id)
		end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
	end
  end
end
