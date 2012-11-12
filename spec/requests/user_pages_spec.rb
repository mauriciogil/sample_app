require 'spec_helper'

describe 'User pages' do

  subject { page }

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    it { have_h1(user.name) }
    it { have_title(user.name) }
  end

  describe "signup page" do
    before { visit signup_path }
    it { have_h1('Sign up') }
    it { have_title('Sign up') }

  end

  describe "signup" do
    before { visit signup_path}
    let(:submit) { "Create my account"}

    describe "with invalid information" do
      it "should not create a user" do
        # The following line calculates User.count before and after the execution
        # of click_button "Create my account"
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        describe "Blank name should show an error message" do
          before do
            fill_in "Name",         with: ""
          end
          before { click_button submit }
          it { should have_selector('title', text: 'Sign up')}
          it { should have_content("Name can't be blank") }
        end

        describe "Blank email should show an error message" do
          before do
            fill_in "Email",         with: ""
          end
          before { click_button submit }
          it { should have_selector('title', text: 'Sign up')}
          it { should have_content("Email can't be blank") }
        end

        describe "Blank password should show an error message" do
          before do
            fill_in "Password",         with: ""
          end
          before { click_button submit }
          it { should have_selector('title', text: 'Sign up')}
          it { should have_content("Password can't be blank") }
        end

        describe "Short password should show an error message" do
          before do
            fill_in "Password",         with: "12345"
          end
          before { click_button submit }
          it { should have_selector('title', text: 'Sign up')}
          it { should have_content("Password is too short (minimum") }
        end

        describe "Confirmation password should be equal to password" do
          before do
            fill_in "Password",         with: "123456"
            fill_in "Confirmation",     with: "1234567"
          end
          before { click_button submit }
          it { should have_selector('title', text: 'Sign up')}
          it { should have_content("Password doesn't match confirmation") }
        end
      end

    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }
        it { should have_selector('title', text: user.name)}
        it { should have_selector('div.alert.alert-success', text: 'Welcome')}
        it { should have_link('Sign out') }
      end
    end
  end
end
