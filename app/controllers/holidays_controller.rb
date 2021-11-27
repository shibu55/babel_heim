class HolidaysController < ApplicationController
  def index
  end

  def new
    @holiday = Holiday.new
  end

  def create
    Holiday.create(holiday_parameter)
    redirect_to root_path
  end

  private

  def holiday_parameter
    params.require(:holiday).permit(:title, :content, :start_time)
  end
end
