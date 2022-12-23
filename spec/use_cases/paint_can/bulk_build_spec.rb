require "rails_helper"

RSpec.describe PaintCan::BulkBuild, type: :use_case do
  describe "failure" do
    context "with invalid attributes" do
      context "when paint_cans is not an array" do
        it "returns a failure" do
          result = described_class.call(paint_cans: "wrong")

          expect(result).to be_failure
          expect(result[:paint_cans]).to include("must be an array")
        end
      end

      context "when one of the paint_cans has missing params" do
        it "returns a failure" do
          result = described_class.call(paint_cans: [{}])

          expect(result).to be_failure
          expect(result[:paint_cans][0]).to include(
            size: ["is missing"],
            area_per_liter: ["is missing"]
          )
        end
      end
    end
  end

  describe "success" do
    it "returns paint cans" do
      paint_cans = [
        { size: 4, area_per_liter: 2.5 },
        { size: 7, area_per_liter: 3 }
      ]
      result = described_class.call(paint_cans:)

      expect(result).to be_success
      expect(result[:paint_cans]).to contain_exactly(
        have_attributes(size: 4, area_per_liter: 2.5),
        have_attributes(size: 7, area_per_liter: 3)
      )
    end

    context "without paint_cans param" do
      it "returns default paint cans" do
        result = described_class.call

        expect(result).to be_success
        expect(result[:paint_cans]).to contain_exactly(
          have_attributes(size: 18, area_per_liter: 5),
          have_attributes(size: 3.6, area_per_liter: 5),
          have_attributes(size: 2.5, area_per_liter: 5),
          have_attributes(size: 0.8, area_per_liter: 5)
        )
      end
    end
  end
end
