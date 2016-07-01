require "rails_helper"

describe Lesson, ".upcoming" do

  it "only includes lessons today or after" do
    today = create(:lesson)
    create(:lesson, :past)
    future = create(:lesson, :future)

    expect(Lesson.upcoming).to match_array [today, future]
  end

end

describe Lesson, ".completed" do

  it "only includes lessons after today" do
    create(:lesson)
    create(:lesson, :future)
    yesterday = create(:lesson, :past)

    expect(Lesson.completed).to match_array [yesterday]
  end

end

describe Lesson, ".goals" do

  it "is embedded" do

  end

end

describe Lesson, ".date" do

  it "is present" do

  end

end

describe Lesson, ".users" do

end

describe Lesson, ".school" do

end

describe Lesson, "#given_by?" do

  it "returns true when the passed user has given this lesson" do

  end

  it "returns false when the passed user has not given this lesson" do

  end

end
