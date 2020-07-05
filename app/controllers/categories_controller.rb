class CategoriesController < ApplicationController

  def index
    @parents = Category.where(ancestry: nil)
    @images = ["forest.jpg", "flower.jpg", "mountain.jpg", "ground.jpg", "sea.jpg", "river.jpg", "sky.jpg", "snow.jpg"]
  end

  def show
    @category = Category.find(params[:id])
    @pictures = @category.set_pictures.order("created_at DESC").page(params[:page]).per(20)
  end

  def children
    @children = Category.find(params[:parentCategory]).children
  end

end