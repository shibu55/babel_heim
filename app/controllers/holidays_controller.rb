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
