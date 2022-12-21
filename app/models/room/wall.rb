class Room
  class Wall < Surface
    attr_accessor :doors, :windows

    validates :area, numericality: { in: 1..50 }

    validate :height_must_be_greater_than_doors, if: -> { doors.any? }
    validate :area_must_be_twice_openings, if: -> { doors.any? || windows.any? }

    def paintable_area = area - openings_area

    private

    def openings_area = @openings_area ||= [*doors, *windows].sum(&:area)

    def height_must_be_greater_than_doors
      min_height = doors.max_by(&:height).height + 0.3.to_d
      errors.add(:height, :greater_than_or_equal_to, count: min_height) if height < min_height
    end

    def area_must_be_twice_openings
      min_area = openings_area * 2
      errors.add(:area, :greater_than_or_equal_to, count: min_area) if area < min_area
    end
  end
end
