class Room
  include ActiveModel::Model

  attr_accessor :walls

  validates :walls, length: { is: 4 }
end
