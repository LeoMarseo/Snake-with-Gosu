# Obstacle class spawns random obstacles

class ObstacleSet
  def initialize
    @obstacles = []
    @obstacles << Obstacle.new(Game::GRID)
  end

  def all
    @obstacles
  end

  def add_obstacle
    @obstacles << Obstacle.new(Game::GRID)
  end

  def draw
    @obstacles.each do |obstacle|
      Gosu.draw_rect(obstacle.x, obstacle.y, 20, 20, obstacle.color, z = obstacle.z, mode = :default)
    end
  end
end


class Obstacle
  attr_reader :x, :y, :color, :z

  def initialize(grid)
    @color = Gosu::Color::WHITE
    # build an array of x value fro 0 to grid[:width] - grid[:cell_size]
    # with increment grid[:cell_size]
    @size = grid[:cell_size]
    @x = random_location_in((0..grid[:width] - @size))
    @y = random_location_in((0..grid[:height] - @size))
    @z = 2
  end

  private

  def random_location_in(range)
    range.to_a.select { |n| (n % @size).zero? }.map(&:to_f).sample
  end
end
