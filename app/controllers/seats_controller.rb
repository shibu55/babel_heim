class SeatsController < ApplicationController
  before_action :authenticate_admin!
  def update
    @seat = Seat.find(params[:id])
    @seat.is_used = !@seat.is_used
    @seat.update(seat_params)
  end

  def update_all
    Seat.find_each {|seat| seat.update!(is_used: false)}
    redirect_back(fallback_location: root_path)
  end

  private
    def seat_params
      params.require(:seat).permit(:is_used)
    end
end
