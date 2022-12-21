require "rails_helper"

RSpec.describe Rooms::PaintUseCase, type: :use_case do
  describe "success" do
    it "returns the painted area" do
      wall = build(:room_wall, width: 4.25, height: 8)
      room = build(:room, walls: [wall, wall, wall, wall])
      result = described_class.call(room:)

      expect(result).to be_success
      expect(result[:area]).to eq(125.72)
    end

    it "returns used paint cans and quantity for each" do
      wall = build(:room_wall, width: 4.25, height: 8)
      room = build(:room, walls: [wall, wall, wall, wall])
      result = described_class.call(room:)

      expect(result).to be_success
      expect(result[:paint_cans]).to include(
        have_attributes(size: 18, area_per_liter: 5) => 1,
        have_attributes(size: 3.6, area_per_liter: 5) => 1,
        have_attributes(size: 2.5, area_per_liter: 5) => 1,
        have_attributes(size: 0.8, area_per_liter: 5) => 2
      )
    end

    context "when room is too small" do
      it "returns the smallest paint can" do
        wall = build(:room_wall, width: 0.1, height: 0.1, doors: [], windows: [])
        room = build(:room, walls: [wall, wall, wall, wall])
        result = described_class.call(room:)

        expect(result).to be_success
        expect(result[:paint_cans]).to include(have_attributes(size: 0.8) => 1)
      end
    end

    context "when room does not have walls" do
      it "does not return any paint can" do
        room = build(:room, walls: [])
        result = described_class.call(room:)

        expect(result).to be_success
        expect(result[:paint_cans]).to be_empty
      end
    end
  end
end
