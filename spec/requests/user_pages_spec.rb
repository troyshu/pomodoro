require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Sign up') }
    it { should have_selector('title', text: 'Sign up') }
  end
	
  describe "the act of signing up on the signup page" do
	before { visit signup_path }
	let(:submit) { "Create my account" }

	describe "with invalid information" do
		it "should not create a user" do
			expect { click_button submit }.not_to change(User, :count)
		end
	end

	describe "with VALID information" do
		before do
			fill_in "Name", 			with: "Example user"
			fill_in "Email", 			with: "example@example.com"
			fill_in "Password", 		with: "foobar"
			fill_in "Confirmation", 	with: "foobar"
		end

		it "should create a user" do
			expect { click_button submit }.to change(User, :count).by(1)
			

		end

		describe "after saving the user" do
			before { click_button submit }
			it { should have_link('Sign out', href: signout_path) }
		end

		
	end
  end

  describe "profile page" do
  	let(:user) { FactoryGirl.create(:user) }
	let!(:p1) { FactoryGirl.create(:finished_pomodoro, user:user, created_at: 1.day.ago) }
	let!(:p2) { FactoryGirl.create(:pomodoro, user:user, created_at: 1.minute.ago) }
	let!(:p3) { FactoryGirl.create(:finished_pomodoro, user:user, created_at: 1.hour.ago) }

	before { visit user_path(user) }

	it { should have_selector('h1', text:user.name) }
	it { should have_selector('title', text:user.name) }

	describe "pomodoros should not include unfinished pomodoros" do
		it { should have_content("#{p1.length} minutes") }
		it { should have_content("#{p3.length} minutes") }
		it { should_not have_content("#{p2.length} minutes") }
	end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit edit_user_path(user) }


    describe "page" do
      it { should have_selector('h1',    text: "Update your profile") }
      it { should have_selector('title', text: "Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end

  end

end