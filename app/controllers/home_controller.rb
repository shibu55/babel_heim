class HomeController < ApplicationController
  def index
    @seats = Seat.all
    @holidays = Holiday.all
    @shifts = Shift.all
    @is_open = Holiday.where(start_time: Time.zone.today.beginning_of_day...Time.zone.today.end_of_day).empty?
    @shop_config = ShopConfig.first
    @news = News.order(created_at: :desc).limit(2)
  end
end
