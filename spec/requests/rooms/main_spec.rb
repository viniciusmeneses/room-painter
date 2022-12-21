require "rails_helper"

RSpec.describe "Rooms management", type: :request do
  describe "POST /rooms/paint" do
    context "when params are valid" do
      it "responds with status code 200" do
        wall = build(:room_wall)
        wall_param = {
          width: wall.width,
          height: wall.height,
          doors: wall.doors.size,
          windows: wall.windows.size
        }

        post "/rooms/paint", params: { walls: [wall_param, wall_param, wall_param, wall_param] }

        expect(response).to have_http_status(:ok)
      end

      it "responds with area and paint_cans as json" do
        wall = build(:room_wall)
        wall_param = {
          width: wall.width,
          height: wall.height,
          doors: wall.doors.size,
          windows: wall.windows.size
        }

        post "/rooms/paint", params: { walls: [wall_param, wall_param, wall_param, wall_param] }
        body = parse_json(response.body)

        expect(body).to include(
          area: 96.32,
          paint_cans: [{ quantity: 1, size: 18.0 }, { quantity: 2, size: 0.8 }]
        )
      end
    end

    context "when params are invalid" do
      it "responds with status code 422" do
        post "/rooms/paint", params: { walls: [] }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "responds with errors as json" do
        post "/rooms/paint", params: { walls: nil }
        body = parse_json(response.body)

        expect(body).to include(errors: { walls: ["must be an array"] })
      end
    end
  end
end
