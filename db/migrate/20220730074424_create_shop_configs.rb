class CreateShopConfigs < ActiveRecord::Migration[6.1]
  def change
    create_table :shop_configs do |t|
      t.string :open_hour
      t.string :close_hour
      t.string :last_order_hour
      t.boolean :is_show_news

      t.timestamps
    end
  end
end
