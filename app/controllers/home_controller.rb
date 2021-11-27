class HomeController < ApplicationController
  def index
    @seats = Seat.all
    @holidays = Holiday.all
  end
end
