class Room
  include ActiveModel::Model

  attr_accessor :walls

  validates :walls, length: { is: 4 }

  def paintable_area = @paintable_area ||= walls.sum(&:paintable_area)
end
