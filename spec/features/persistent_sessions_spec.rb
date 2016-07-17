require "spec_helper"

describe "persistent sessions" do
  
  before :each do
    create(:user, :activated, email: "user@example.com", password: "password")
  end

  it "logs the user in throughout the session" do
    visit "login"
    within "#session" do
      fill_in "Email", with: "user@example.com"
      fill_in "Password", with: "password"
    end
    click_button "Log in"
    expect(page).to have_content "Log out"
    visit "users/" + User.find_by(email: "user@example.com").id
    expect(page).to have_content "Log out"
  end

  it "can remember the user across multiple sessions" do
    visit "login"
    within "#session" do
      fill_in "Email", with: "user@example.com"
      fill_in "Password", with: "password"
      check "Remember me"
    end
    click_button "Log in"
    expect(page).to have_content "Log out"
    @sesson = Capybara::Session.new(:selenium)
    visit "/"
    expect(page).to have_content "Log out"
  end
end
