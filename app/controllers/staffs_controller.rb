class StaffsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_staff, only: [:edit, :update, :destroy]

  def index
    @staffs = Staff.all
  end

  def new
    @staff = Staff.new
  end

  def create
    @staff = Staff.new(staff_params)
    if @staff.save
      redirect_to staffs_path, notice: 'スタッフを登録しました。'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @staff.update(staff_params)
      redirect_to staffs_path, notice: 'スタッフ情報を更新しました。'
    else
      render :edit
    end
  end

  def destroy
    @staff.destroy
    redirect_to staffs_path, notice: 'スタッフを削除しました。'
  end

  private

  def set_staff
    @staff = Staff.find(params[:id])
  end

  def staff_params
    params.require(:staff).permit(:name)
  end
end
