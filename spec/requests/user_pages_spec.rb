require 'spec_helper'

describe 'User pages' do

  subject { page }

  describe 'index' do
    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_selector('title', text: 'All users') }
    it { should have_selector('h1',    text: 'All users') }

    describe 'pagination' do

      before(:all) { 30.times { FactoryGirl.create(:user) }}
      after(:all) { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end
    describe 'delete links' do

      it { should_not have_link('delete') }

      describe 'as an admin user' do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

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

  describe 'edit' do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe 'page' do
      it { have_h1("Update your profile") }
      it { have_title("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe 'with invalid information' do
      before { click_button "Save changes" }
      it { should have_content('error') }
    end

    describe 'with valid information' do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",         with: new_name
        fill_in "Email",        with: new_email
        fill_in "Password",     with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }
    end
  end
end
