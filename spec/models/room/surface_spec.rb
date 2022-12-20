require "rails_helper"

RSpec.describe Room::Surface, type: :model do
  context "with correct attributes" do
    it "is valid" do
      surface = build(:room_surface)
      expect(surface).to be_valid
    end
  end

  describe "#area" do
    it "calculates area based on width and height" do
      surface = build(:room_surface, width: 6, height: 8)

      area = surface.area

      expect(area).to eq(48)
    end
  end
end
