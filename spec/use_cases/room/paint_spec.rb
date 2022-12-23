require "rails_helper"

RSpec.describe Room::Paint, type: :use_case do
  describe "failure" do
    context "with invalid attributes" do
      context "when room is blank" do
        it "returns a failure" do
          result = described_class.call

          expect(result).to be_failure
          expect(result.data).to include(room: ["must be filled"], paint_cans: ["must be filled"])
        end
      end
    end
  end

  describe "success" do
    it "returns the painted area" do
      wall = build(:room_wall, width: 4.25, height: 8)
      room = build(:room, walls: [wall, wall, wall, wall])
      paint_cans = [build(:paint_can)]
      result = described_class.call(room:, paint_cans:)

      expect(result).to be_success
      expect(result[:area]).to eq(125.72)
    end

    it "returns used paint cans and quantity for each" do
      wall = build(:room_wall, width: 4.25, height: 8)
      room = build(:room, walls: [wall, wall, wall, wall])
      paint_cans = [
        build(:paint_can, size: 2, area_per_liter: 5),
        build(:paint_can, size: 1, area_per_liter: 5),
        build(:paint_can, size: 0.8, area_per_liter: 5)
      ]
      result = described_class.call(room:, paint_cans:)

      expect(result).to be_success
      expect(result[:paint_cans]).to include(
        have_attributes(size: 2, area_per_liter: 5) => 12,
        have_attributes(size: 1, area_per_liter: 5) => 1,
        have_attributes(size: 0.8, area_per_liter: 5) => 1
      )
    end

    context "when room is too small" do
      it "returns the smallest paint can" do
        wall = build(:room_wall, width: 0.1, height: 0.1, doors: [], windows: [])
        room = build(:room, walls: [wall, wall, wall, wall])
        paint_cans = [build(:paint_can, size: 0.8, area_per_liter: 5)]
        result = described_class.call(room:, paint_cans:)

        expect(result).to be_success
        expect(result[:paint_cans]).to include(have_attributes(size: 0.8) => 1)
      end
    end

    context "when room does not have walls" do
      it "does not return any paint can" do
        room = build(:room, walls: [])
        paint_cans = [build(:paint_can)]
        result = described_class.call(room:, paint_cans:)

        expect(result).to be_success
        expect(result[:paint_cans]).to be_empty
      end
    end
  end
end
