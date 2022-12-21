require "rails_helper"

RSpec.describe Room, type: :model do
  context "with correct attributes" do
    it "is valid" do
      room = build(:room)
      expect(room).to be_valid
    end
  end

  describe "#walls" do
    context "when size is not 4" do
      it "is invalid" do
        room = build(:room, walls: [])
        expect(room).to be_invalid
      end
    end
  end

  describe "#paintable_area" do
    it "calculates area based on walls paintable area" do
      door = build(:room_surface, width: 1, height: 2)
      window = build(:room_surface, width: 2, height: 1)
      wall = build(:room_wall, width: 10, height: 5, doors: [door], windows: [window])
      room = build(:room, walls: [wall, wall])

      paintable_area = room.paintable_area

      expect(paintable_area).to eq(92)
    end
  end
end
