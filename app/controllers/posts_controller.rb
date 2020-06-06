class PostsController < ApplicationController

  def index
    if params[:author_id]
      @posts = Author.find(params[:author_id]).posts
    else
      @posts = Post.all
    end
  end

  def show
    if params[:author_id]
      @post = Author.find(params[:author_id]).posts.find(params[:id])
    else
      @post = Post.find(params[:id])
    end
  end

  def new
    binding.pry
    # if it contains the author_id in params with a value and if the author does not exits. 
    if params[:author_id] && !Author.exists?(params[:author_id])
      redirect_to authors_path, alert: "Author not found."
    else 
      @post = Post.new(author_id: params[:author_id])
    end
    
  end

  def create
    @post = Post.new(post_params)
    @post.save
    redirect_to post_path(@post)
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    redirect_to post_path(@post)
  end

  def edit
    # checking to see if the nested route http://localhost:3000/authors/4/posts/18/edit was use vs posts/18/edit
    if params[:author_id]
      # looks to see if the author provided exist in the database
      author = Author.find_by(id: params[:author_id])
      if author.nil?
        redirect_to authors_path, alert: "Author not found."
      else 
        # if the @post is not nil than the default will send this info to the update.
        @post = author.posts.find_by(id: params[:id])
        redirect_to author_posts_path(author), alert: "Post not found." if @post.nil?
      end
    else  
      # if no nested route this gets call
      @post = Post.find(params[:id])
      # update is call 
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :description, :author_id)
  end
end
