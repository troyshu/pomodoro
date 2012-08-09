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
		it "should go to home/root" do
			before { click_link "Home" }
			it { should have_selector('title', text: full_title('')) }
		end


    end
  end

end