class HomeController < ApplicationController
  def index
    @seats = Seat.all
  end
end
