class TagsController < ApplicationController
  before_action :set_tag
  before_action :set_picture, only: :picture
  before_action :set_tags, only: :picture

  def show
    @pictures = @tag.pictures.order("created_at DESC").page(params[:page]).per(20)
  end

  def picture
    @previous = @pictures[@index + 1]
    @next = @pictures[@index - 1] if @index != 0
    @count = @pictures.index(@picture) + 1
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def set_picture
    @picture = Picture.find(params[:picture_id])
    @category = @picture.category
    @pictures = @tag.pictures.order("pictures.created_at ASC")
    @index = @pictures.index(@picture)
  end
  
  def set_tags
    @tag_list = @picture.tags.pluck(:name).join(",")
    @all_tags = Tag.pluck(:name)
  end

end