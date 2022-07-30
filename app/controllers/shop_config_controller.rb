class ShopConfigController < ApplicationController
  def edit_hour
    @shop_config = ShopConfig.first
  end

  def update_hour
    @shop_config = ShopConfig.first
    if @shop_config.update(shop_config_parameter)
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private
  def shop_config_parameter
    params.require(:shop_config).permit(:open_hour, :close_hour, :last_order_hour)
  end
end
