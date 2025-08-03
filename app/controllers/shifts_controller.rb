class ShiftsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_shift, only: [:edit, :update, :destroy]

  def index
    @shifts = Shift.includes(:staff).order(start_time: :desc)
    @holidays = Holiday.all
    @staffs = Staff.all
  end

  def new
    @shift = Shift.new
    @staffs = Staff.all
  end

  def create
    @shift = Shift.new(shift_params)
    if @shift.save
      redirect_to shifts_path, notice: 'シフトを登録しました。'
    else
      @shifts = Shift.includes(:staff).order(start_time: :desc)
      @holidays = Holiday.all
      @staffs = Staff.all
      render :index
    end
  end

  def edit
    @staffs = Staff.all
  end

  def update
    if @shift.update(shift_params)
      redirect_to shifts_path, notice: 'シフトを更新しました。'
    else
      @staffs = Staff.all
      render :edit
    end
  end

  def destroy
    @shift.destroy
    redirect_to shifts_path, notice: 'シフトを削除しました。'
  end

  private

  def set_shift
    @shift = Shift.find(params[:id])
  end

  def shift_params
    params.require(:shift).permit(:staff_id, :start_time)
  end
end
