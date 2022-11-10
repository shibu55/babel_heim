class HolidaysController < ApplicationController
  def index
  end

  def new
    @holiday = Holiday.new
    @holidays = Holiday.all
  end

  def create
    Holiday.create(holiday_parameter)
    redirect_to new_holiday_path
  end

  def create_regular_holidays
    current_year = Time.current.year
    wmonth = params[:month].to_i
    wday = params[:day].to_i
    wdays = [:sunday,:monday,:tuesday,:wednesday,:thursday,:friday,:saturday]
    first = Time.local(current_year, wmonth)
    if first.wday == wday
      target_day = first
    else
      target_day = first.next_occurring(wdays[wday])
    end
    while target_day.month == wmonth do
      Holiday.create({title: "店休日", start_time: target_day})
      target_day = target_day.next_occurring(wdays[wday])
    end

    redirect_to new_holiday_path
  end

  def destroy
    @holiday = Holiday.find(params[:id])
    @holiday.destroy
    redirect_to new_holiday_path
  end

  def edit
    @holiday = Holiday.find(params[:id])
  end

  def update
    @holiday = Holiday.find(params[:id])
    if @holiday.update(holiday_parameter)
      redirect_to new_holiday_path
    else
      render 'edit'
    end
  end

  private

  def holiday_parameter
    params.require(:holiday).permit(:title, :content, :start_time)
  end
end
