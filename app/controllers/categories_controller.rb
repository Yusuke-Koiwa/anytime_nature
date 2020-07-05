class CategoriesController < ApplicationController
  before_action :set_category, only: :show

  def index
    @parents = Category.where(ancestry: nil)
    @images = ["forest.jpg", "flower.jpg", "mountain.jpg", "ground.jpg", "sea.jpg", "river.jpg", "sky.jpg", "snow.jpg"]
  end

  def show
    @pictures = @category.set_pictures.order("created_at DESC").page(params[:page]).per(20)
  end
  
  def children
    @children = Category.find(params[:parentCategory]).children
  end
  
  private
  
  def set_category
    @category = Category.find(params[:id])
    if @category.root?
      @category_links = @category.children
    else
      @category_links = @category.siblings
    end
  end

end