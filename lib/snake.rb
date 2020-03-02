class Snake
  SIZE = 20
  attr_reader :x, :y, :score, :direction, :tails

  def initialize(x, y, color)
    @color = color
    @x = x
    @y = y
    @z = 1
    @direction = 'left'
    @score = 0
    @tails = []
    @length = 1
  end

  def go_left
    @direction = 'left'
  end

  def go_right
    @direction = 'right'
  end

  def go_up
    @direction = 'up'
  end

  def go_down
    @direction = 'down'
  end

  def increase_score
    @score += 1
  end

  def grow
    @length += 1
  end

  def move
    update_tail_movement
    update_head_movement
  end

  def draw
    Gosu.draw_rect(@x, @y, SIZE, SIZE, @color, z = @z, mode = :default)
    @tails.each do |tail|
      Gosu.draw_rect(tail.first, tail.last, SIZE, SIZE, @color, z = @z, mode = :default)
    end
  end

  def target(target_x, target_y, obstacles)
    if target_x < @x && 1200 - @x + target_x >= @x - target_x
      go_down if @direction == "right"
      go_left
      avoid_obstacles(obstacles, @direction)
    elsif target_x < @x && 1200 - @x + target_x < @x - target_x
      go_down if @direction == "right"
      go_right
      avoid_obstacles(obstacles, @direction)
    elsif target_x > @x && @x + 1200 - target_x >= target_x - @x
      go_down if @direction == "left"
      go_right
      avoid_obstacles(obstacles, @direction)
    elsif target_x > @x && @x + 1200 - target_x < target_x - @x
      go_down if @direction == "left"
      go_left
      avoid_obstacles(obstacles, @direction)
    elsif target_y < @y && 800 - @y + target_y <= @y - target_y
      go_right if @direction == "down"
      go_down
      avoid_obstacles(obstacles, @direction)
    elsif target_y < @y && @y && 800 - @y + target_y > @y - target_y
      go_right if @direction == "down"
      go_up
      avoid_obstacles(obstacles, @direction)
    elsif target_y > @y && 800 - target_y + @y <= target_y - @y
      go_right if @direction == "up"
      go_up
      avoid_obstacles(obstacles, @direction)
    elsif target_y > @y && 800 - target_y + @y > target_y - @y
      go_right if @direction == "up"
      go_down
      avoid_obstacles(obstacles, @direction)
    end
  end

  def avoid_obstacles(obstacles, direction)
    if direction == "right"
      go_up if obstacles.all.any? { |obstacle| obstacle.x == @x + SIZE && obstacle.y == @y }
    elsif direction == "left"
      go_up if obstacles.all.any? { |obstacle| obstacle.x == @x - SIZE && obstacle.y == @y }
    elsif direction == "down"
      go_left if obstacles.all.any? { |obstacle| obstacle.y == @y + SIZE && obstacle.x == @x }
    elsif direction == "up"
      go_left if obstacles.all.any? { |obstacle| obstacle.y == @y - SIZE && obstacle.x == @x }
    end
  end

  def avoid_tails(tails)
    case @direction
    when "right"
      go_up if tails.any? { |tail| tail[0] == @x + SIZE && tail[1] == @y }
    when "left"
      go_up if tails.any? { |tail| tail[0] == @x - SIZE && tail[1] == @y }
    when "down"
      go_left if tails.any? { |tail| tail[1] == @y + SIZE && tail[0] == @x }
    when "up"
      go_left if tails.any? { |tail| tail[1] == @y - SIZE && tail[0] == @x }
    end
  end

  private

  def update_head_movement
    case @direction
    when 'left' then @x -= SIZE
    when 'right' then @x += SIZE
    when 'up' then @y -= SIZE
    when 'down' then @y += SIZE
    end
    # remove next part if you want borders to kill the snake
    x = 0
    y = 0
    if @x == Game::GRID[:width]
      x = -Game::GRID[:width]
    elsif @x < 0
      x = Game::GRID[:width]
    end
    if @y == Game::GRID[:height]
      y = -Game::GRID[:height]
    elsif @y < 0
      y = Game::GRID[:height]
    end
    @x += x
    @y += y
  end

  def update_tail_movement
    @tails.unshift([@x, @y])
    @tails.pop if @tails.size == @length
  end
end
