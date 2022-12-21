class Room
  class Surface
    include ActiveModel::Model

    attr_accessor :width, :height

    def area = width * height
  end
end
