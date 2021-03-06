require 'spec_helper'

describe "Static pages" do
  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  subject { page }    # page is the subjects of the tests

  shared_examples_for "all static pages" do 
    it { should have_selector('h1', text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading) { 'Sample App' }
    let(:page_title) { '' }
    it_should_behave_like "all static pages" 
    it { should_not have_selector 'title', text: '| Home' }

    describe "for signed-in users" do
      let(:user) {FactoryGirl.create(:user)}
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      # test for sidebar microposts counts and proper pluralization (ex 10.1)
      it "should have the right micropost count and pluralization" do
        page.should have_selector('span', text: "2 microposts")
      end

      it "should render the user's feed" do
        user.feed.each do |item| 
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      # testing the following/follower statistics on the home page
      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it {should have_link("0 following", href: following_user_path(user))}
        it {should have_link("1 follower",  href: followers_user_path(user))}
      end
    end
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading) { 'Help' }
    let(:page_title) { 'Help' }
    it_should_behave_like "all static pages"
  end

  describe "About page" do 
    before { visit about_path }
    let(:heading) { 'About' }
    let(:page_title) { 'About' }
    it_should_behave_like "all static pages"
  end

  describe "Contact page" do 
    before { visit contact_path }
    let(:heading) { 'Contact' }
    let(:page_title) { 'Contact' }
    it_should_behave_like "all static pages" 
  end

  # test for the links on the layout (checks that links go to the right pages)
  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', text: full_title('About')
    click_link "Help"
    page.should have_selector 'title', text: full_title('Help')
    click_link "Contact" 
    page.should have_selector 'title', text: full_title('Contact')
    click_link "Home"
    # click_link "Sign up now!"
    # page.should have_selector 'title', text: full_title('Sign up here')
    # click_link "sample app" 
    # page.should have_selector 'title', text: full_title('Sample App')
  end
end 
#   describe "Home page" do
#     before { visit root_path }  # synonymous with before(:each), this creates
#     # a before block to visit root path before each example
    
#     it { should have_selector('h1', text: 'Sample App') }
#     it {should have_selector 'title', text: full_title('')}
#     it {should_not have_selector 'title', text: '| Home'}
#   	# what's in quotes is for humans, irrelevant to RSpec
    
#       # Run the generator again with the --webrat flag if you want to use webrat
#       # methods/matchers
#       # original: get static_pages_index_path
#       # response.status.should be(200)
#       # use Capybara function visit to simulate visiting URI /static_pages/home 
#       # in browser
#       # use Capybara page variable to test content in resulting page
#       # remember to use bundle exec with command:
#       # rspec spec/requests/static_pages_spec.rb
#       # to ensure RSpec runs in environment specified by Gemfile
#       # page.should have_selector('h1', :text => 'Sample App')
#   end

#   describe "Help page" do 
#     before { visit help_path }
#     it { should have_selector('h1', text: 'Help') }
#     it { should have_selector('title', text: full_title('Help')) }
#   end

#   describe "About page" do
#     before { visit about_path }
#     it { should have_selector('h1', text: 'About')}
#     it { should have_selector('title', text: full_title('About')) }
#   end

#   # old about spec 
#   # describe "About page" do 
#   #   it "should have the h1 'About'" do 
#   #     visit about_path
#   #     page.should have_selector('h1', :text => "About")
#   #   end

#   #   it "should have the title 'About'" do 
#   #     visit about_path
#   #     page.should have_selector('title', 
#   #       :text => "#{base_title} | About")
#   #   end
#   # end

#   describe "Contact page" do 
#     before { visit contact_path }
#     it {should have_selector('h1', text: 'Contact')}
#     it {should have_selector('title', text: full_title('Contact'))}
#   end
# end
