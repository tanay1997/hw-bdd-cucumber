class Movie < ActiveRecord::Base

  def self.all_ratings
    return ['G','PG','PG-13','R']
  end

  def self.with_ratings(ratings)
    @ratings_to_show = []
    @ratings_to_show = ratings
    @movies = Movie.where(rating: ratings)
  end

  def self.ratings_to_show
    return @ratings_to_show
  end

end

