require "rails_helper"
require "spec_helper"

describe User, '.mentor' do

  it 'returns only non-admin users' do
    create(:user, :admin)
    mentor = create(:user)

    result = User.mentor

    expect(result).to eq [mentor]
  end

end

describe User, '.email' do

  it 'is a valid email fomat' do
    invalid_emails = ["invalid @ retsku.com", 
                      "not and email", 
                      "invalid/@character.com",]

    invalid_emails.each do |email|
      user = build(:user, email: email)

      expect(user.valid?).to be false
    end
  end

  it 'is downcased before saving' do
    user = create(:user, email: "CapitAlized@GMail.coM")

    expect(user.email).to eq("capitalized@gmail.com")
  end

  it 'is under 255 characters' do
    user = build(:user, email: "#{"a" * 255 }@gmail.com")

    expect(user.valid?).to be false
  end

  it 'is unique' do
    user = create(:user, email: "test@gmail.com")

    expect(User.all).to eq [user]

    user2 = build(:user, email: "test@gmail.com")

    expect(user2.valid?).to be false
  end

  it 'is present' do
    user = build(:user, email: "    ")

    expect(user.valid?).to be false
  end

end


describe User, '.name' do

  it 'is be present' do
    user = build(:user, name: "      ")

    expect(user.valid?).to be false
  end

  it 'is at least 6 characters' do
    user = build(:user, name: "Ben")

    expect(user.valid?).to be false
  end

  it 'is above 50 characters' do
    user = build(:user, name: "A" * 51)

    expect(user.valid?).to be false
  end

  it 'is unique' do
    user = create(:user, name: "John Smith")

    expect(User.all).to eq [user]

    user2 = build(:user, name: "John Smith")

    expect(user2.valid?).to be false
  end

end


describe User, '.phone' do

  it 'is 10 characters' do
    user = build(:user, phone: "123456789")

    expect(user.valid?).to be false
  end

  it 'is only numerical characters' do
    user = build(:user, phone: ("123456789a"))

    expect(user.valid?).to be false
  end

  it 'is unique' do
    user = create(:user, phone: "1234567890")

    expect(User.all).to eq [user]

    user2 = build(:user, phone: "1234567890")

    expect(user2.valid?).to be false
  end

end

describe User, '.admin' do

  it 'forces the email to be hosted @debatemate.com' do
    user = build(:user, :admin, email: "admin@gmail.com")

    expect(user.valid?).to be false
  end

end

describe User, '.password' do

  it 'is at least 6 characters' do
    user = build(:user, password: "short")

    expect(user.valid?).to be false
  end

  it 'is present' do
    user = build(:user, password: "      ")

    expect(user.valid?).to be false
  end

end

describe User, '.password_confirmation' do

  it 'equals .password' do
    user = build(:user, password: "abcdef", password_confirmation: "bcdefg")

    expect(user.valid?).to be false
  end

end

describe User, '#first_name' do

  it 'is the first word in the name' do
    names = ["Jonathan", "Jonathan Smith", "Jonathan H. Smith"]

    names.each do |name|
      user = create(:user, name: name)

      expect(user.first_name).to eq "Jonathan"
    end
  end

end


describe User, "#schools" do

  it "returns a list of the names of all the schools the user has been to" do
    user = create(:user)
    school1 = create(:school)
    school2 = create(:school)
    create(:lesson, school: school1, users: [user, create(:user)])
    create(:lesson, school: school1, users: [user])
    create(:lesson, school: school2, users: [user])

    expect(user.schools).to match_array [school1, school2]
  end

  it 'has no duplicates' do

  end

end

describe User, "#authenticated?" do

  it 'works for different values' do
    token = Token.new
    token2 = Token.new
    user = create(:user, password_digest: token.digest, 
                         reset_digest: token2.digest)

    expect(user.authenticated?("password", token.token)).to be true
    expect(user.authenticated?("reset", token2.token)).to be true
    expect(user.authenticated?("password", token2.token)).to be false
    expect(user.authenticated?("reset", token.token)).to be false
  end

  context "when the passed attribute doesn't exist" do

    it "raises an error" do
      expect { create(:user).authenticated?("invalid", "token") }
        .to raise_error(NoMethodError)
    end

  end
end

describe User, "#create_reset_digest" do

  it "generates a new token and sets reset_sent_at to the current time" do
    Timecop.freeze
    user = create(:user)
    user.create_reset_digest

    expect(user.reset_token).to_not be_nil
    expect(user.reset_digest).to_not be_nil
    expect(user.reset_sent_at).to eq(Time.zone.now)
    token = user.reset_token
    digest = user.reset_digest
    time = user.reset_sent_at
    expect(user.authenticated?("reset", token)).to be true

    Timecop.return
    user.create_reset_digest

    expect(user.reset_token).to_not eq(token)
    expect(user.reset_digest).to_not eq(digest)
    expect(user.reset_sent_at).to be > time
  end
end
