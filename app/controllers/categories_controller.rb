class CategoriesController < ApplicationController

  def index
    @parents = Category.where(ancestry: nil)
    @images = ["forest.jpg", "flower.jpg", "mountain.jpg", "ground.jpg", "sea.jpg", "river.jpg", "sky.jpg", "snow.jpg"]
  end

  def show
  end

  def children
    @children = Category.find(params[:parentCategory]).children
  end

end