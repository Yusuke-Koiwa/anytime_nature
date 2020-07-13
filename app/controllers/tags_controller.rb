class TagsController < ApplicationController
  before_action :set_tag

  def show
    @pictures = @tag.pictures.order("created_at DESC").page(params[:page]).per(20)
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

end