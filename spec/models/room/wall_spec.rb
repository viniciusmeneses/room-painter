require "rails_helper"

RSpec.describe Room::Wall, type: :model do
  context "with correct attributes" do
    it "is valid" do
      wall = build(:room_wall)
      expect(wall).to be_valid
    end
  end

  describe "#height" do
    describe "when highest door plus 30 centimeters is greater than wall height" do
      it "is invalid" do
        door = build(:room_surface, width: 1, height: 1.5)
        wall = build(:room_wall, height: 1.3, doors: [door])

        expect(wall).to be_invalid
      end
    end
  end

  describe "#area" do
    context "when is not between 1 and 50" do
      it "is invalid" do
        wall = build(:room_wall, width: 10, height: 20)
        expect(wall).to be_invalid
      end
    end

    context "when doors and windows area is greater than 50% of wall area" do
      it "is invalid" do
        door = build(:room_surface, width: 3, height: 5)
        window = build(:room_surface, width: 7, height: 2)
        wall = build(:room_wall, width: 8, height: 6, doors: [door], windows: [window])

        expect(wall).to be_invalid
      end
    end
  end

  describe "#paintable_area" do
    it "calculates area without doors and windows" do
      door = build(:room_surface, width: 1, height: 2)
      window = build(:room_surface, width: 2, height: 1)
      wall = build(:room_wall, width: 8, height: 6, doors: [door], windows: [window])

      paintable_area = wall.paintable_area

      expect(paintable_area).to eq(44)
    end
  end
end
