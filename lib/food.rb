# Food class spawns a dot at a random location

class Food
  attr_reader :x, :y

  def initialize(grid)
    @color = Gosu::Color::RED
    # build an array of x value fro 0 to grid[:width] - grid[:cell_size]
    # with increment grid[:cell_size]
    @size = grid[:cell_size]
    @x = random_location_in((0..grid[:width] - @size))
    @y = random_location_in((0..grid[:height] - @size))
  end

  def draw
    Gosu.draw_rect(@x, @y, @size, @size, @color)
  end

  def wrong_location?(obstacles, snake_one, snake_two)
    if obstacles.all.any? { |obstacle| obstacle.x == @x && obstacle.y == @y }
      true
    elsif snake_one.tails.any? { |tail| tail[0] == @x && tail[1] == @y }
      true
    elsif snake_two.tails.any? { |tail| tail[0] == @x && tail[1] == @y }
      true
    else
      false
    end
  end

  private

  def random_location_in(range)
    range.to_a.select { |n| (n % @size).zero? }.map(&:to_f).sample
  end
end
