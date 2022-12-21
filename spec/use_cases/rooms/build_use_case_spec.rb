require "rails_helper"

RSpec.describe Rooms::BuildUseCase, type: :use_case do
  describe "failure" do
    context "with invalid attributes" do
      context "when walls is not an array" do
        it "returns a failure" do
          result = described_class.call(walls: nil)

          expect(result).to be_failure
          expect(result[:walls]).to include("must be an array")
        end
      end

      context "when one of the walls has missing params" do
        it "returns a failure" do
          result = described_class.call(walls: [{}])

          expect(result).to be_failure
          expect(result[:walls][0]).to include(
            doors: ["is missing"],
            height: ["is missing"],
            width: ["is missing"],
            windows: ["is missing"]
          )
        end
      end
    end

    context "when room is invalid" do
      it "returns a failure" do
        result = described_class.call(walls: [{ width: 1, height: 1, doors: 0, windows: 0 }])

        expect(result).to be_failure
        expect(result.type).to eq(:invalid_room)
        expect(result[:walls]).to include("size must be 4")
      end
    end

    context "when walls are invalid" do
      it "returns a failure" do
        wall = { width: 2, height: 500, doors: 0, windows: 0 }
        result = described_class.call(walls: [wall, wall, wall, wall])

        expect(result).to be_failure
        expect(result.type).to eq(:invalid_walls)
        expect(result[:walls]).to include(
          0 => { area: ["must be in 1..50"] },
          1 => { area: ["must be in 1..50"] },
          2 => { area: ["must be in 1..50"] },
          3 => { area: ["must be in 1..50"] }
        )
      end
    end
  end

  describe "success" do
    it "returns a new room" do
      wall = { width: 2, height: 2, doors: 0, windows: 0 }
      result = described_class.call(walls: [wall, wall, wall, wall])

      expect(result).to be_success
      expect(result[:room]).to be_a(Room)
      expect(result[:room].walls).to all(have_attributes(width: 2, height: 2))
    end

    context "with doors" do
      it "returns a new room" do
        wall = { width: 5, height: 3, doors: 1, windows: 0 }
        result = described_class.call(walls: [wall, wall, wall, wall])

        expect(result).to be_success
        expect(result[:room].walls).to all(have_attributes(
          doors: [have_attributes(width: 0.8, height: 1.9)]
        ))
      end
    end

    context "with windows" do
      it "returns a new room" do
        wall = { width: 5, height: 3, doors: 0, windows: 1 }
        result = described_class.call(walls: [wall, wall, wall, wall])

        expect(result).to be_success
        expect(result[:room].walls).to all(have_attributes(
          windows: [have_attributes(width: 2.0, height: 1.2)]
        ))
      end
    end
  end
end
