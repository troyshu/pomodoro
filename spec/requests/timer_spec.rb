require 'spec_helper'

describe "Timer" do
	describe "sign in first" do
		let(:user) { FactoryGirl.create(:user) }

		before do 
			visit signin_path
			valid_signin(user)
		end

		describe "after clicking Start" do
			before do
				visit root_path 
				click_button "Start"
			end
			
			#test BROKEN...
			it "should create a new pomodoro" do
				expect { sleep(3) }.to change(Pomodoro, :count).by(1)
			end

		end
	end

	describe "after clicking Start" do
		before do
			visit root_path 
			click_button "Start"
		end

		it "should NOT create a new pomodoro (not signed in)" do
			expect { sleep(3) }.to change(Pomodoro, :count).by(0)
		end



		#also the length of this pomodoro should be non-zero
	end
end