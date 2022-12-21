FactoryBot.define do
  factory :room_wall, class: "Room::Wall" do
    width { 7 }
    height { 4 }

    doors do
      surface = build(:room_surface, width: 0.8, height: 1.9)
      [surface]
    end

    windows do
      surface = build(:room_surface, width: 1.5, height: 0.7)
      [surface, surface]
    end
  end
end
