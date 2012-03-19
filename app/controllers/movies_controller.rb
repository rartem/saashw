class MoviesController < ApplicationController

helper_method :title_class
helper_method :date_class

def title_class
  return @@title_class
end

def date_class
  return @@date_class
end
   
  @@title_class = 'none'
  @@date_class = 'none' 
   
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie
    @all_ratings = Movie.uniq.pluck(:rating)
    
    
    if params[:commit] == "Refresh"
      ratings = params[:ratings]
      if ratings != nil
        @movies = @movies.where(:rating => ratings.keys)
      else
        @movies = @movies.limit(0)
      end
    end
    
    case params[:sort]
    when "title"  then 
      @movies = @movies.order('title asc').all
      @@title_class = 'hilite'
      @@date_class = 'none'
    when "date" then 
      @movies = @movies.order('release_date asc').all
      @@title_class = 'none'
      @@date_class = 'hilite'
    else
      @movies = @movies.all 
      @@title_class = 'none'
      @@date_class = 'none'
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

end
