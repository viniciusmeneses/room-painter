module Rooms
  class MainController < ApplicationController
    def paint
      Room::Build.call(**params.permit!)
        .then(PaintCan::BulkBuild)
        .then(Room::Paint)
        .on_success do |result|
          render(json: {
            area: result[:area].to_f,
            paint_cans: result[:paint_cans].map { |paint_can, quantity| { size: paint_can.size.to_f, quantity: } }
          })
        end
        .on_failure { |result| render(status: :unprocessable_entity, json: { errors: result.data }) }
    end
  end
end
