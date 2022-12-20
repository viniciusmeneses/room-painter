require "rails_helper"

RSpec.describe PaintCan, type: :model do
  context "with correct attributes" do
    it "is valid" do
      paint_can = build(:paint_can)
      expect(paint_can).to be_valid
    end
  end

  describe "#size" do
    context "when is blank" do
      it "is invalid" do
        paint_can = build(:paint_can, size: nil)
        expect(paint_can).to be_invalid
      end
    end

    context "when is not greater than 0" do
      it "is invalid" do
        paint_can = build(:paint_can, size: 0)
        expect(paint_can).to be_invalid
      end
    end
  end

  describe "#area_per_liter" do
    context "when is blank" do
      it "is invalid" do
        paint_can = build(:paint_can, area_per_liter: nil)
        expect(paint_can).to be_invalid
      end
    end

    context "when is not greater than 0" do
      it "is invalid" do
        paint_can = build(:paint_can, area_per_liter: 0)
        expect(paint_can).to be_invalid
      end
    end
  end

  describe "#paint_area" do
    it "calculates area based on size and area_per_liter" do
      paint_can = build(:paint_can, size: 2, area_per_liter: 5)

      area = paint_can.paint_area

      expect(area).to eq(10)
    end
  end
end
