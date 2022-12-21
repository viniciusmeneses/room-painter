module Rooms
  class PaintUseCase < ApplicationUseCase
    Schema = Dry::Schema.Params do
      required(:room).filled
      required(:paint_cans).array(:hash) do
        required(:size).filled(:decimal)
        required(:area_per_liter).filled(:decimal)
      end
    end

    DEFAULT_PAINT_CANS = [
      { size: 18, area_per_liter: 5 },
      { size: 3.6, area_per_liter: 5 },
      { size: 2.5, area_per_liter: 5 },
      { size: 0.8, area_per_liter: 5 }
    ]

    attribute :room
    attribute :paint_cans, default: DEFAULT_PAINT_CANS

    def execute
      paintable_area = room.paintable_area

      needed_paint_cans = calculate_needed_cans(
        cans: build_paint_cans,
        paintable_area:
      )

      Success(result: { area: paintable_area, paint_cans: needed_paint_cans })
    end

    private

    def build_paint_cans
      paint_cans.map do |can|
        PaintCan.new(
          size: can[:size],
          area_per_liter: can[:area_per_liter]
        )
      end
    end

    def calculate_needed_cans(paintable_area:, cans:)
      remaining_area = paintable_area

      cans.each.with_index.reduce({}) do |quantities, (can, index)|
        paint_area = can.paint_area

        quantity = (remaining_area / paint_area).floor
        remaining_area -= paint_area * quantity
        quantity += 1 if last_can?(index) && remaining_area.positive?

        quantity.positive? ? { **quantities, can => quantity } : quantities
      end
    end

    def last_can?(index) = paint_cans.size - 1 == index
  end
end
