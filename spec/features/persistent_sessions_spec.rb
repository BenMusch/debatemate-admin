require "spec_helper"

describe "persistent sessions" do
  before :each do
    user = create(:user, :activated)
    @email = user.email
    @password = user.password
  end

  it "logs the user in throughout the session" do
    login_with email: @email, password: @password
    expect(page).to have_content "Log out"
    visit "users/" + User.find_by(email: @email).id
    expect(page).to have_content "Log out"
  end

  it "can remember the user across multiple sessions" do
    visit "login"
    within "#session" do
      fill_in "Email", with: @email
      fill_in "Password", with: @password
      check "Remember me"
    end
    click_button "Log in"
    expect(page).to have_content "Log out"
    @sesson = Capybara::Session.new(:selenium)
    visit "/"
    expect(page).to have_content "Log out"
  end
end
