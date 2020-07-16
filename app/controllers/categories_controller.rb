class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show picture parent_picture slideshow]
  before_action :set_search, only: %i[show slideshow]
  before_action :set_picture, only: %i[picture parent_picture]
  before_action :set_pictures, only: %i[picture parent_picture]
  before_action :set_tags, only: %i[picture parent_picture]
  before_action :set_comments, only: %i[picture parent_picture]

  def index
    @parents = Category.where(ancestry: nil)
    @images = ["forest.jpg", "flower.jpg", "mountain.jpg", "ground.jpg", "sea.jpg", "river.jpg", "sky.jpg", "snow.jpg"]
  end

  def show
    @pictures = @q.result(distinct: true).includes(:category).page(params[:page]).per(20)
  end

  def slideshow
    @pictures = @q.result(distinct: true).includes(:category).page(params[:page]).per(10)
  end

  def picture;end

  def parent_picture;end
  
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

  def set_search
    @params = search_params
    @q = @category.set_pictures.ransack(@params)
  end

  def set_picture
    @picture = Picture.find(params[:picture_id])
  end

  def set_pictures
    @pictures = @category.set_pictures
    @previous = @pictures.where("id > ?", @picture.id).order("id ASC").first
    @next = @pictures.where("id < ?", @picture.id).order("id DESC").first
    @count = @pictures.index(@picture) + 1
  end

  def set_tags
    @tag_list = @picture.tags.pluck(:name).join(",")
    @all_tags = Tag.pluck(:name)
  end
  
  def set_comments
    @comment = Comment.new
    @comments = @picture.comments.includes(:user).order("created_at DESC").page(params[:page]).per(10)
  end

  def search_params
    if params[:q].present?
      params.require(:q).permit(:sorts)
    else
      params[:q] = { sorts: 'id desc' }
    end
  end

end