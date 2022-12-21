module Rooms
  class MainController < ApplicationController
    def paint
      Rooms::BuildUseCase.call(**params.permit!)
        .then(Rooms::PaintUseCase)
        .on_success do |result|
          render(json: {
            area: result[:area].to_f,
            paint_cans: result[:paint_cans].map do |paint_can, quantity|
              { size: paint_can.size.to_f, quantity: }
            end
          })
        end
        .on_failure { |result| render(status: :unprocessable_entity, json: { errors: result.data }) }
    end
  end
end
