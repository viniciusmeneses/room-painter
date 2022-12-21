module Rooms
  class BuildUseCase < Micro::Case
    attributes :walls

    Schema = Dry::Schema.Params do
      required(:walls).array(:hash) do
        required(:width).filled(:decimal)
        required(:height).filled(:decimal)
        required(:doors).filled(:integer)
        required(:windows).filled(:integer)
      end
    end

    BuildSurface = ->(width:, height:) { Room::Surface.new(width: width.to_d, height: height.to_d) }

    def call!
      schema = Schema[attributes]
      return Failure(:invalid_attributes, result: schema.errors.to_h) if schema.failure?

      room = build_room(**schema.to_h)
      validate_room(room)
    end

    private

    def build_room(walls:)
      room_walls = walls.map do |wall|
        Room::Wall.new(
          **wall,
          doors: Array.new(wall[:doors]) { BuildSurface[width: 0.8, height: 1.9] },
          windows: Array.new(wall[:windows]) { BuildSurface[width: 2.0, height: 1.2] }
        )
      end

      Room.new(walls: room_walls)
    end

    def validate_room(room)
      return Failure(:invalid_room, result: room.errors.messages) if room.invalid?

      if room.walls.map(&:invalid?).any?
        messages = room.walls.map { |wall| wall.errors.messages }
        messages_by_index = messages.index_by.with_index { |_, index| index }.select { |_, messages| messages.any? }
        return Failure(:invalid_walls, result: { walls: messages_by_index })
      end

      Success(result: { room: })
    end
  end
end
