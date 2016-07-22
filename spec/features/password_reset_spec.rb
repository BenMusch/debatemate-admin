require "spec_helper"

describe "resetting the password" do

  before :each do
    user = create(:user, :activated)
    @email = user.email
  end

  it "allows users to reset their password via email" do
    submit_reset_for @email
    expect(page).to have_content "Email sent"
    open_email @email
    expect(current_email).to have_content "reset your password"
    visit current_email.find("//a")[:href]
    expect(page).to have_content "Reset password"
    update_password_with "newpassword"
    expect(page).to have_content "Log out"
    click_link "Log out"
    login_with email: @email, password: "newpassword"
    expect(page).to have_content "Log out"
  end

  it "forces valid submissions" do
    submit_reset_for @email
    open_email @email
    visit current_email.find("//a")[:href]
    update_password_with "      "
    expect(page).to have_content "Password cannot be blank"
    expect(page).to have_no_content "Log out"
    update_password_with "not_equivalent", "passwords"
    expect(page).to have_content "Password confirmation doesn't match Password"
    expect(page).to have_no_content "Log out"
  end

  it "forces registered emails" do
    visit "/login"
    click_link "(forgot password)"
    within "#reset" do
      fill_in "Email", with: "invalid@fake.com"
    end
    click_on "Submit"
    expect(page).to have_content("No user found")
  end

  it "expires in 2 hours" do
    submit_reset_for @email
    open_email @email
    Timecop.travel(Time.now + 3.hours)
    visit "/password_resets/invalid/edit?email=" + @email.gsub("@", "%40")
    expect(page).to have_content "Invalid reset link"
  end

  def submit_reset_for(email)
    visit "/login"
    click_link "(forgot password)"
    within "#reset" do
      fill_in "Email", with: email
    end
    click_on "Submit"
  end

  def update_password_with(password, confirmation=nil)
    within "#reset" do
      fill_in "Password", with: password
      fill_in "Password confirmation", with: confirmation || password
    end
    click_on "Update password"
  end
end
