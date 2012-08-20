require 'spec_helper'

describe "Static pages" do
	
	#todo style home page correctly

  describe "Home page" do
	subject { page }
	before { visit root_path }
    it "should have the correct title and content" do
      should have_content('pomodoro timer')
      should have_selector 'title', text: full_title('')
    end

    describe "nav links" do
		describe "should go to home/root when Home clicked" do
			before { click_link "Home" }
			it { should have_selector('title', text: full_title('')) }

		end
		
		describe "should go to home/root when logo clicked" do
			before { click_link "logo" }
			it { should have_selector('title', text: full_title('')) }

		end

		#test broken, because blog opens in new window
		#describe "should go to blog" do
		#	it { should have_link('Blog', href: 'http://www.pomos-blog.posterous.com') }
		#end

		describe "should go to help page" do
			before { click_link "Help" }
			it { should have_selector('title', text: full_title('Help')) }
		end

		describe "should have sign in link" do
			it { should have_link('Sign in') }
		end
		describe "should not have sign out link" do
			it {should_not have_link('Account')}
		end

    end

	describe "footer links" do
		before { click_link "Contact" }
		it { should have_selector('title', text: full_title('Contact')) }
	end

  end

end