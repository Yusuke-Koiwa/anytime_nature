class CategoriesController < ApplicationController

  def children
    @children = Category.find(params[:parentCategory]).children
  end

end