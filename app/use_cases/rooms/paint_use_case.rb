module Rooms
  class PaintUseCase < Micro::Case
    attributes :room, required: true

    BuildPaintCan = ->(size:, area_per_liter: 5.0) { PaintCan.new(size: size.to_d, area_per_liter: area_per_liter.to_d) }

    def call!
      remaining_area = room.paintable_area

      quantity_by_paint_can = paint_cans.each.with_index.reduce({}) do |quantities, (can, index)|
        quantity = (remaining_area / can.paint_area).floor
        remaining_area -= can.paint_area * quantity

        is_last_can = paint_cans.size - 1 == index
        quantity += 1 if is_last_can && remaining_area.positive?

        quantity.positive? ? { **quantities, can => quantity } : quantities
      end

      Success(result: { area: room.paintable_area, paint_cans: quantity_by_paint_can })
    end

    private

    def paint_cans
      @paint_cans ||= [
        BuildPaintCan[size: 18.0],
        BuildPaintCan[size: 3.6],
        BuildPaintCan[size: 2.5],
        BuildPaintCan[size: 0.8]
      ]
    end
  end
end
