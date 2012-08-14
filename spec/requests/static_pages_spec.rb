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

		describe "should go to blog" do
			before { click_link "Blog" }
			it { should have_content('blog') }
		end

		describe "should go to help page" do
			before { click_link "Help" }
			it { should have_selector('title', text: full_title('Help')) }
		end

    end

	describe "footer links" do
		before { click_link "Contact" }
		it { should have_selector('title', text: full_title('Contact')) }
	end

  end

end