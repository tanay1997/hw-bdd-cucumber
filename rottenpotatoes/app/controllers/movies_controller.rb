class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
   
   # @movies = Movie.all
   @all_ratings = Movie.all_ratings
   @sort = params[:sort] || session[:sort]
   session[:ratings] = params[:ratings] if params[:commit] == "Refresh"

   if params[:ratings] == nil and session[:ratings] == nil
     @ratings_to_show = @all_ratings
     @movies = Movie.all
   else
     @ratings = params[:ratings] || session[:ratings] 
     redirect_to(movies_path(ratings: @ratings, sort: @sort)) if params[:ratings] == nil
     @movies = Movie.with_ratings(@ratings.keys)
     @ratings_to_show = Movie.ratings_to_show
     session[:ratings] = @ratings
   end

   if not (params[:sort] == nil and session[:sort] == nil)
     @movies = @movies.order(@sort)
     session[:sort] = @sort
   end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  private
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end

end
