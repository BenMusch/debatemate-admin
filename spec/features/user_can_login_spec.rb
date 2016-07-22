require "spec_helper"

describe "the sign in process" do

  it "logs the user in" do
    create(:user, :activated)
    email = User.first.email
    visit "login"
    within "#session" do
      fill_in "Email", with: email
      fill_in "Password", with: "password"
    end
    click_button "Log in"
    expect(page).to have_content "Log out"
  end

  it "forces activation" do
    create(:user, email: "user@example.com", password: "password")
    visit "login"
    within "#session" do
      fill_in "Email", with: "user@example.com"
      fill_in "Password", with: "password"
    end
    click_button "Log in"
    expect(page).to have_no_content "Log out"
    expect(page).to have_content "not activated"
  end

end
