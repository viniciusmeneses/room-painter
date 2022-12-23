class PaintCan::BulkBuild < Micro::Case
  Schema = Dry::Schema.Params do
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

  attribute :paint_cans, default: DEFAULT_PAINT_CANS

  def call!
    Success(result: { paint_cans: build_paint_cans })
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
end
