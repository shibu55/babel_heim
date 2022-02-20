class HomeController < ApplicationController
  def index
    @seats = Seat.all
    @holidays = Holiday.all
    @is_open = Holiday.where(start_time: Time.zone.today.beginning_of_day...Time.zone.today.end_of_day).empty?
  end
end
