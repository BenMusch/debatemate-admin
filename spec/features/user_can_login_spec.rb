require "spec_helper"

describe "the sign in process" do
  it "logs the user in" do
    user = create(:user, :activated)
    login_with email: user.email, password: user.password
    expect(page).to have_content "Log out"
  end

  it "forces activation" do
    user = create(:user, activated: false)
    login_with email: user.email, password: user.password
    expect(page).to have_no_content "Log out"
    expect(page).to have_content "not activated"
  end
end
