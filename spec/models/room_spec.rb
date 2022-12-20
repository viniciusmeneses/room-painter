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
        paint_can = build(:room, walls: [])
        expect(paint_can).to be_invalid
      end
    end
  end
end
