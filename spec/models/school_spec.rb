require "rails_helper"

describe School, ".name" do

  it "is present" do
    school = School.new(name: "  ")
    expect(school.valid?).to be false
  end

  it "is unique" do
    school = create(:school, name: "Hillborough High")
    school.save
    school = School.new(name: "Hillborough High")
    expect(school.valid?).to be false
  end

end

describe School, ".lessons" do

  it "returns the lessons that reference this school" do
    school = create(:school)
    lesson = create(:lesson, school: school, users: [create(:user)])
    lesson2 = create(:lesson, school: school, users: [create(:user)])
    lesson3 = create(:lesson, school: school, users: [create(:user)])

    expect(school.lessons).to match_array([lesson, lesson2, lesson3])
  end

end
