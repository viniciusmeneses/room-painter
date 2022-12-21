FactoryBot.define do
  factory :room_wall, class: "Room::Wall" do
    width { 7 }
    height { 4 }

    doors { Array.new(1) { association(:room_surface, width: 0.8, height: 1.9) } }
    windows { Array.new(1) { association(:room_surface, width: 1.5, height: 0.7) } }
  end
end
