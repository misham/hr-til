class PostsController < ApplicationController

  include MarkdownHelper

  expose(:developer) { current_developer }
  expose(:post, attributes: :post_params)
  expose(:posts) { developer.posts }

  before_filter :require_developer, except: :index

  def create
    if post.save
      redirect_to root_path
    else
      flash[:alert] = post.errors.full_messages
      render :new
    end
  end

  def index
    self.posts = Post.order created_at: :desc
  end

  def sorted_tags
    Tag.order name: :asc
  end
  helper_method :sorted_tags

  private

  def post_params
    params.require(:post).permit :body, :tag_id
  end
end