require 'gosu'
require_relative 'snake'
require_relative 'food'
require_relative 'obstacle'

class Game < Gosu::Window
  GRID = {
    width: 60 * Snake::SIZE,
    height: 40 * Snake::SIZE,
    cell_size: Snake::SIZE
  }.freeze
  SCORE = {
    size: GRID[:cell_size] + 10,
    x: GRID[:width] - 220,
    y: 10,
    z: 1.0,
    scale: 1.0,
    color: Gosu::Color.rgb(100, 269, 260)
  }.freeze
  EN_SCORE = {
    size: GRID[:cell_size] + 10,
    x: 20,
    y: 10,
    z: 1.0,
    scale: 1.0,
    color: Gosu::Color.rgb(105, 96, 71)
  }.freeze
  @speed = START_SPEED = 0.1
  SPEED_INCREMENT = 0.003

  def initialize
    super GRID[:width], GRID[:height]
    self.caption = "Gosu Snake"
    @font = Gosu::Font.new(SCORE[:size], bold: true)
    @start_sound = Gosu::Sample.new("media/mac_start.wav")
    @eat_sound = Gosu::Sample.new("media/beep.mp3")
    @bad_eat_sound = Gosu::Sample.new("media/punch.wav")
    @bad_reset_sound = Gosu::Sample.new("media/negative_beep.mp3")
    @background_image = Gosu::Image.new("media/snake-bg.jpg")
    reset_game
  end

  def update
    return if (Time.now - @last_move) < @speed
    set_snake_direction
    @bad_snake.target(@food.x, @food.y, @obstacles)
    @bad_snake.avoid_tails(@snake.tails)

    # out_of_bound? || ## uncomment this and add to the condition below to implement borders
    if obstacle_collision?(@snake) || self_collision?(@snake) || snake_collision_with_other_snake?(@bad_snake, @snake)
      reset_game
    elsif obstacle_collision?(@bad_snake) || snake_collision_with_other_snake?(@snake, @bad_snake)
      reset_bad_snake && @bad_reset_sound.play && sleep(1)
    end
      @snake.move && @bad_snake.move

    if eat?(@snake)
      @eat_sound.play
      reset_food
      calculate_score(@snake)
      increase_difficulty
    end

    if eat?(@bad_snake)
      @bad_eat_sound.play
      reset_food
      calculate_score(@bad_snake)
      @bad_snake.grow
      @obstacles.add_obstacle
    end

    @last_move = Time.now
  end

  def draw
    @background_image.draw(0, 0, 0)
    @snake.draw
    @bad_snake.draw
    @food.draw
    @obstacles.draw
    @font.draw_markup("Player Score: #{@snake.score}", SCORE[:x], SCORE[:y], SCORE[:z], SCORE[:scale], SCORE[:scale], SCORE[:color])
    @font.draw_markup("Enemy Score: #{@bad_snake.score}", EN_SCORE[:x], EN_SCORE[:y], EN_SCORE[:z], EN_SCORE[:scale], EN_SCORE[:scale], EN_SCORE[:color])
  end

  def calculate_score(a_snake)
    a_snake.increase_score
  end

  def increase_difficulty
    @speed -= SPEED_INCREMENT
    @snake.grow
    @obstacles.add_obstacle
  end

  # uncomment this method to implement borders
  # def out_of_bound?
  #   @snake.x.negative? || @snake.x > GRID[:width] - GRID[:cell_size] || @snake.y.negative? ||  @snake.y > GRID[:height] - GRID[:cell_size]
  # end

  def self_collision?(a_snake)
    a_snake.tails.any? { |tail| a_snake.x == tail[0] && a_snake.y == tail[1] }
  end

  def snake_collision_with_other_snake?(a_snake, possibly_dead_snake)
    return true if a_snake.x == possibly_dead_snake.x && a_snake.y == possibly_dead_snake.y
    a_snake.tails.any? { |tail| possibly_dead_snake.x == tail[0] && possibly_dead_snake.y == tail[1] }
  end

  def obstacle_collision?(object)
    @obstacles.all.any? { |obstacle| object.x == obstacle.x && object.y == obstacle.y }
  end

  def set_snake_direction
    @snake.go_left if (Gosu.button_down? Gosu::KB_LEFT) && @snake.direction != 'right'
    @snake.go_right if (Gosu.button_down? Gosu::KB_RIGHT) && @snake.direction != 'left'
    @snake.go_up if (Gosu.button_down? Gosu::KB_UP) && @snake.direction != 'down'
    @snake.go_down if (Gosu.button_down? Gosu::KB_DOWN) && @snake.direction != 'up'
  end

  def reset_snake
    @snake = Snake.new(1140, 80, Gosu::Color.rgb(100, 269, 260))
    @speed = START_SPEED
    @last_move = Time.now
  end

  def reset_bad_snake
    @bad_snake = Snake.new(60, 80, Gosu::Color.rgb(105, 96, 71))
    @last_move = Time.now
  end

  def reset_food
    @food = Food.new(GRID)
    while @food.wrong_location?(@obstacles, @snake, @bad_snake) do @food = Food.new(GRID) end
  end

  def reset_obstacle
    @obstacles = ObstacleSet.new
  end

  def eat?(a_snake)
    a_snake.x == @food.x && a_snake.y == @food.y
  end

  def reset_game
    @start_sound.play
    reset_obstacle
    reset_snake
    reset_bad_snake
    reset_food
  end
end

Game.new.show
