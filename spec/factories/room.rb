FactoryBot.define do
  factory :room do
    walls { Array.new(4) { association(:room_wall) } }
  end
end
