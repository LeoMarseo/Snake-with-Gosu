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

  def target(target_x, target_y)
    if target_x < @x
      go_down if @direction == "right"
      go_left
    elsif target_x > @x
      go_down if @direction == "left"
      go_right
    elsif target_y < @y
      go_right if @direction == "down"
      go_up
    elsif target_y > @y
      go_right if @direction == "up"
      go_down
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
