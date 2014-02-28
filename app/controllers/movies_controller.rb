class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = ['G','PG','PG-13','R','NC-17','NR'] #Array of all possible ratings to reference to
    @checked = {}        #Empty array will be filled with checked values

    #sorting stuff------------------------------------------------------------------------------
    if params[:sort] == nil && session[:sort] != nil
      params[:sort] = session[:sort]
    end

    if(params[:sort].to_s == 'title')
    	@movies = @movies.sort_by {|mov| mov.title}
      session[:sort] = params[:sort]
    elsif(params[:sort].to_s == 'release')
    	@movies = @movies.sort_by {|mov| mov.release_date.to_s}
      session[:sort] = params[:sort]
    end

    #rating filters-----------------------------------------------------------------------------
    if (params[:ratings] == nil && session[:ratings] != nil) #case where user unchecks all boxes
      params[:ratings] = session[:ratings]
    end

    if params[:ratings] != nil    #case where ratings params do exist
      @all_ratings.each do |rating|
        @checked[rating] = params[:ratings].has_key?(rating)
      end
    else    #case where no ratings params exist
      @all_ratings.each do |rating|
        @checked[rating] = true     #set all ratings to be checked
      end
    end
    
    if params[:ratings] != nil    #filter based on selected ratings
      @movies = @movies.find_all{|m| params[:ratings].has_key?(m.rating)}
      session[:ratings] = params[:ratings]
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
