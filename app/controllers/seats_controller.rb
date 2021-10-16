class SeatsController < ApplicationController
  def update
    @seat = Seat.find(params[:id])
    @seat.is_used = !@seat.is_used
    @seat.update(seat_params)
  end

  private
    def seat_params
      params.require(:seat).permit(:is_used)
    end
end
