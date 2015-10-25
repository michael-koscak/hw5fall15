class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
  def self.find_in_tmdb(search_term)
    Tmdb::Api.key('f4702b08c0ac6ea5b51425788bb26562')
    matching_movies = Tmdb::Movie.find(search_term)
    
    if matching_movies == nil
      return []
    end
    
    movies = []
    
    matching_movies.each do |tmdb_movie|
      movie = Hash.new
      movie[:id] = tmdb_movie.id
      movie[:title] = tmdb_movie.title
      movie[:release_date] = tmdb_movie.release_date
      movie[:rating] = 'R'
      movies << movie # add the movie to the return array
    end
    
    return movies
  end
  
  def self.create_from_tmdb(tmdb_id) 
    Tmdb::Api.key('f4702b08c0ac6ea5b51425788bb26562')
    tmdb_movie = Tmdb::Movie.detail(tmdb_id)
    
    movie =  Hash.new
    movie['title'] = tmdb_movie["title"]
    movie['description'] = tmdb_movie["overview"]
    movie['release_date'] = tmdb_movie["release_date"]
    movie['rating'] = "R"
    Movie.create!(movie)
    
    return movie
  end
end
