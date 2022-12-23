class Room::Build < Micro::Case
  Schema = Dry::Schema.Params do
    required(:walls).array(:hash) do
      required(:width).filled(:decimal)
      required(:height).filled(:decimal)
      required(:doors).filled(:integer)
      required(:windows).filled(:integer)
    end
  end

  class InvalidRoom < StandardError
    attr_reader :messages
    def initialize(messages) = @messages = messages
  end

  attribute :walls

  def call!
    room = build_room
    validate_room!(room)
    validate_walls!(room.walls)
    Success(result: { room: })
  rescue InvalidRoom => error
    Failure(:invalid_room, result: error.messages)
  end

  private

  def build_room
    room_walls = walls.map do |wall|
      Room::Wall.new(
        **wall,
        doors: Array.new(wall[:doors]) { build_surface(width: 0.8, height: 1.9) },
        windows: Array.new(wall[:windows]) { build_surface(width: 2.0, height: 1.2) }
      )
    end

    Room.new(walls: room_walls)
  end

  def build_surface(width:, height:)
    Room::Surface.new(width: width.to_d, height: height.to_d)
  end

  def validate_room!(room)
    raise InvalidRoom, room.errors.messages if room.invalid?
  end

  def validate_walls!(walls)
    return if walls.map(&:valid?).all?

    messages = walls.map { |wall| wall.errors.messages }
    messages_by_index = messages.index_by.with_index { |_, index| index }.select { |_, messages| messages.any? }
    raise InvalidRoom, walls: messages_by_index
  end
end
