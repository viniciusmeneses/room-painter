class Room::Paint < Micro::Case
  Schema = Dry::Schema.Params do
    required(:room).filled
    required(:paint_cans).filled(:array)
  end

  attribute :room
  attribute :paint_cans

  def call!
    paintable_area = room.paintable_area

    needed_paint_cans = calculate_needed_cans(paintable_area:)

    Success(result: { area: paintable_area, paint_cans: needed_paint_cans })
  end

  private

  def calculate_needed_cans(paintable_area:)
    remaining_area = paintable_area

    paint_cans.each.with_index.reduce({}) do |quantities, (can, index)|
      paint_area = can.paint_area

      quantity = (remaining_area / paint_area).floor
      remaining_area -= paint_area * quantity
      quantity += 1 if last_can?(index) && remaining_area.positive?

      quantity.positive? ? { **quantities, can => quantity } : quantities
    end
  end

  def last_can?(index)
    paint_cans.size - 1 == index
  end
end
