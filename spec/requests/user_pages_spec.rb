require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do 
    let(:user) { FactoryGirl.create(:user) }

    before(:each) do     # same as before but used to contrast with before(:all)
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end

    it {should be_entitled('All users')}
    it {should have_heading(1, 'All users')}

    describe "pagination" do
      before(:all)  { 30.times { FactoryGirl.create(:user) }}
      after(:all)   { User.delete_all }

      it {should have_selector('div.pagination')}

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
        # above replaces:
        # User.all.each do |user|
        #   page.should have_selector('li', text: user.name)
        # end
      end
    end

    describe "delete links" do
      it {should_not have_link('delete')}

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect {click_link('delete')}.to change(User, :count).by(-1)
        end
        it {should_not have_link('delete', href: user_path(admin))}

        # it "should prevent admin users from destroying themselves" do
        #   before { delete user_path(admin) }
        #   it { should have_error_message('Admin cannot delete himself')}
        # end
      end
    end
  end

  describe  "signup page" do
  	before { visit signup_path }


  	it { should have_selector('h1', text: 'Sign up')}
  	# now ommitted:
  	# it { should have_selector('title', text: full_title('Sign up')) }
  	# not sure why. see 7.1.3 of Ruby on Rails Tutorial
  	it { should have_selector('title', text: 'Sign up')}
  end

  describe "signup" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_selector('title', text: 'Sign up') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirm Password", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com')}

        it { should have_selector('title', text: user.name)}
        it { should have_selector('div.alert.alert-success', text: 'Welcome')}
        # tests that newly signed-up users are also signed in
        it { should have_link('Sign out')}
      end
    end
  end

  
  describe "profile page" do 
    # Code to make a user variable using FactoryGirl gem 
    # for generating factories
    let(:user) { FactoryGirl.create(:user) }
  	
  	before { visit user_path(user) }
  	it { should have_selector('h1', 	text: user.name) }
  	it { should have_selector('title', 	text: user.name) }
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do 
      # this no longer works since authorization tests sign us out:
      #   { visit edit_user_path(user) }
      # instead we need to sign in again
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it {should have_selector('h1',    text: "Update your profile")}
      it {should have_selector('title', text: "Edit user")}
      it {should have_link('Change Gravatar', 
                            href: 'http://gravatar.com/emails')}
    end

    describe "with invalid information" do
      before {click_button "Save changes"}

      it {should have_content('error')}
    end

    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it {should be_entitled(new_name)}
      it {should have_selector('div.alert.alert-success')}
      it {should have_link('Sign out', href: signout_path)}
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }
    end
  end

  describe "profile page" do
    let(:user) {FactoryGirl.create(:user)}
    let!(:m1) {FactoryGirl.create(:micropost, user: user, content: "Foo")}
    let!(:m2) {FactoryGirl.create(:micropost, user: user, content: "Bar")}

    before {visit user_path(user)}

    it {should have_heading(1, user.name)}
    it {should be_entitled(user.name)}

    describe "microposts" do
      it {should have_content(m1.content)}
      it {should have_content(m2.content)}
      it {should have_content(user.microposts.count)}

      # test for micropost pagination
      describe "pagination" do
        before(:all) do
          30.times do |n|
            FactoryGirl.create(:micropost, user: user, content: "Foo#{n}") 
          end
        end 
        after(:all)   { user.microposts.delete_all }

        it {should have_selector('div.pagination')}

        it "should list each micropost" do
          Micropost.paginate(page: 1).each do |micropost|
            page.should have_selector('li', text: micropost.content)
          end
          # above replaces:
          # User.all.each do |user|
          #   page.should have_selector('li', text: user.name)
          # end
        end
      end
    end

    # testing the following/follower statistics on the user's profile page
    describe "follower/following counts" do
      let(:other_user) { FactoryGirl.create(:user) }
      before do
        sign_in user
        other_user.follow!(user)
        visit user_path(user)
      end

      it {should have_link("0 following", href: following_user_path(user))}
      it {should have_link("1 follower",  href: followers_user_path(user))}
    end

    describe "follow/unfollow buttons" do
      let(:other_user) {FactoryGirl.create(:user)}
      before {sign_in user}
      describe "following a user" do
        before {visit user_path(other_user)}

        it "should increment the followed user count" do
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end

        describe "toggling the button" do
          before {click_button "Follow"}
          it {should have_selector('input', value: 'Unfollow')}
        end
      end

      describe "unfollowing a user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "should decrement the followed user count" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end

        describe "toggling the button" do
          before {click_button "Unfollow"}
          it {should have_selector('input', value: 'Follow')}
        end
      end
    end
  end

  describe "following/followers" do
    let(:user) {FactoryGirl.create(:user)}
    let(:other_user) {FactoryGirl.create(:user)}

    before {user.follow!(other_user)}
    describe "followed users" do
      before do
        sign_in user
        visit following_user_path(user)
      end

      it {should be_entitled(full_title('Following'))}
      it {should have_heading(3, 'Following')}
      it {should have_link(other_user.name, href: user_path(other_user))}
    end

    describe "followers" do
      before do
        sign_in user
        visit followers_user_path(other_user)
      end

      it {should be_entitled((full_title('Followers')))}
      it {should have_heading(3, 'Followers')}
      it {should have_link(user.name, href: user_path(user))}
    end
  end
end
