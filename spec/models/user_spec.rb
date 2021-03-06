# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  user_level :integer          default(1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do

	before { @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar") }
	subject { @user }
	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:user_level) } #maybe it shouldn't allow access to this field

	it { should respond_to(:password_digest) }
	#virtual fields
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }

	#authenticate
	it { should respond_to(:authenticate) }

	it { should respond_to(:remember_token) }

	#pomodoros
	it { should respond_to(:pomodoros) }

	it { should be_valid }
	
	#user name tests
	describe "when name is not present" do
		before { @user.name = " " }
		it { should_not be_valid }
	end

	describe "when name is to long" do
		before { @user.name = "a" * 51 }
		it { should_not be_valid }
	end

	#user email tests
	describe "when email is not present" do
		before { @user.email = " " }
		it { should_not be_valid }
	end

	describe "when email format is invalid" do
		it "should be invalid" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
			addresses.each do |invalid_address| 
				@user.email = invalid_address
				@user.should_not be_valid
			end
		end
	end

	describe "when email format is valid" do
		it "should be valid" do 
			addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
			addresses.each do |valid_address|
				@user.email = valid_address
				@user.should be_valid
			end
		end
	end

	describe "when email address is already taken" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end

		it { should_not be_valid }
	end

	#user password tests
	describe "when password field is empty" do
		before { @user.password = @user.password_confirmation = " " }
		it { should_not be_valid }
	end

	describe "when password confirmation doesn't match" do
		before { @user.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end

	describe "when password confirmation is NIL" do #can only really happen using console...
		before { @user.password_confirmation = nil }
		it { should_not be_valid }
	end

	describe "when password is too short" do
		before { @user.password = @user.password_confirmation = "a"*5 }
		it { should_not be_valid }
	end

	#authentication
	describe "return value of authenticate method" do
		before { @user.save }
		let(:found_user) { User.find_by_email(@user.email) }

		describe "with valid password" do
			it { should==found_user.authenticate(@user.password) }
		end

		describe "with invalid password" do
			let (:user_for_invalid_password) { found_user.authenticate("wrong_password") }
			it { should_not == user_for_invalid_password }
			specify { user_for_invalid_password.should be_false }
		end
	end

	describe "remember token" do
		before { @user.save }
		its(:remember_token) { should_not be_blank }
	end

	#pomodoro associations
	describe "pomodoro associations" do
		before { @user.save }
		let!(:older_pomodoro) do
			FactoryGirl.create(:finished_pomodoro, user: @user, created_at: 1.day.ago)
		end
		let!(:newer_pomodoro) do
			FactoryGirl.create(:finished_pomodoro, user: @user, created_at: 1.hour.ago)
		end

		it "should have the pomodoros in the right order (ignoring unfinished ones)" do
			@user.pomodoros.should == [newer_pomodoro, older_pomodoro]
		end

		it "should destroy associated pomodoros once user is destroyed" do
			pomodoros = @user.pomodoros
			@user.destroy
			pomodoros.each do |pomodoro|
				Pomodoro.find_by_id(pomodoro.id).should be_nil
			end
		end
	end
end
