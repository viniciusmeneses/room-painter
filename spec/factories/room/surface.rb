FactoryBot.define do
  factory :room_surface, class: "Room::Surface" do
    width { 8 }
    height { 6 }
  end
end
