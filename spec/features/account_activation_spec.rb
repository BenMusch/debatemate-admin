require "spec_helper"

describe "the sign up process" do

  it "forces activation via email" do
    visit "users/new"
    within "#user" do
      fill_in "Name", with: "Test Person"
      fill_in "Email", with: "user@example.com"
      fill_in "Phone", with: 1234567890
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password"
    end
    click_on "Create my account"
    expect(page).to have_content "check your email"
    expect(page).to have_no_content "Log out"
    open_email "user@example.com"
    expect(current_email).to have_content "activate your account"
    visit current_email.find('//a')[:href]
    expect(page).to have_content "Account activated"
    expect(page).to have_content "Log out"
  end

end
