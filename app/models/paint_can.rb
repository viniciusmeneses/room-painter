class PaintCan
  include ActiveModel::Model

  attr_accessor :size, :area_per_liter

  validates :size, :area_per_liter, numericality: { greater_than: 0 }

  def paint_area = size * area_per_liter
end
