require "rails_helper"

RSpec.describe "Rooms management", type: :request do
  describe "POST /rooms/paint" do
    it "responds with status code 200" do
      post "/rooms/paint"
      expect(response).to have_http_status(:ok)
    end
  end
end
