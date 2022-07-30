class NewsController < ApplicationController
  def index
    @news = News.all
  end

  def new
    @news = News.new
  end
  
  def create
    News.create(news_parameter)
    redirect_to news_index_path
  end

  def show
    @news = News.find(params[:id])
  end

  def edit
    @news = News.find(params[:id])
  end

  def update
    @news = News.find(params[:id])
    if @news.update(news_parameter)
      redirect_to news_index_path
    else
      render 'edit'
    end
  end

  def destroy
    @news = News.find(params[:id])
    @news.destroy
    redirect_to news_index_path
  end

  def update_is_show_news
    shop_config = ShopConfig.first
    shop_config.update_column(:is_show_news, !shop_config.is_show_news)
    shop_config.save!
    redirect_to root_path
  end

  private

  def news_parameter
    params.require(:news).permit(:title, :content)
  end
end
