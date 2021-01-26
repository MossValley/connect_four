require 'pry'

class TokenNodes
  attr_accessor :data, :left, :right, :down, :l_down, :r_down

  def initialize (data=nil)
    @data = data
    @data_row = data[0].to_i
    @data_collumn = data[-1].to_i

    @left = nil
    @right = nil
    @down = nil
    @l_down = nil
    @r_down = nil
  end

  def self_connections
    return {
      'left' => @left,
      'right' => @right, 
      'down' => @down, 
      'l_down' => @l_down,
      'r_down' => @r_down
  }
  end

  def connect_checker(token)
    token_row = token.data[0].to_i
    token_collumn = token.data[-1].to_i
    if token_collumn +1 == @data_collumn ||
      token_collumn -1 == @data_collumn ||
      token_row +1 == @data_row
      attach_node(token, token_row, token_collumn)
    end
  end

  private

  def attach_node(token, token_r, token_c)
    return @left = token if token_r == @data_row && token_c +1 == @data_collumn
    return @right = token if token_r == @data_row && token_c -1 == @data_collumn
    return @down = token if token_r +1 == @data_row && token_c == @data_collumn

    return @l_down = token if token_r +1 == @data_row && token_c +1 == @data_collumn
    return @r_down = token if token_r +1 == @data_row && token_c -1 == @data_collumn
  end
end

class Cage

  def initialize
    @slot = "[ ]"
    @rows = (1..6).to_a.reverse
    @columns = (1..7).to_a
    @cage = generate_cage
  end

  def display_cage
    return cage_display
  end

  def players_move(player, move)
    @rows.reverse.each do |r|
      key = "#{r}, #{move}"
      if @cage[key] == @slot
        @cage[key] = "[#{player.icon}]"
        return key
      end
    end
    return false
  end

  private

  def cage_display
    displayer = "\n 1  2  3  4  5  6  7\n"
    @rows.each do |r|
      @columns.each do |c|
        key = "#{r}, #{c}"
        displayer += @cage[key]
      end
      displayer += "\n"
    end
    displayer
  end

  def generate_cage
    cage_hash = {}
    @rows.each do |r|
      @columns.each do |c|
        key = "#{r}, #{c}"
        cage_hash[key] = @slot
      end
    end
   cage_hash
  end

end

class Player
  attr_accessor :icon, :winner
  
  def initialize (icon)
    @icon = icon
    @winner = false
    @moves_made = []
  end

  def player_move
    puts  "what column do you want to place your #{@icon}?:"
    choice = $stdin.gets.chomp.to_i
    return false if choice < 1 || choice > 7
    choice
  end

  def get_icon_location(cage, choice)
    move_made = cage.players_move(self, choice)
    if move_made
      create_token_node(move_made)
      return true
    else
      return move_made
    end
  end

  private

  def create_token_node(move_made)
    new_token = TokenNodes.new(move_made)
    @moves_made << new_token
    @moves_made.each do |token|
      new_token.connect_checker(token)
    end
    check_winner(new_token)
  end

  def check_winner(token, direction=nil, counter=0)
    root = token
    return counter if root.nil?

    if direction.nil?
      list = root.self_connections
      list.each_pair do |link, node|
        if !node.nil?
          total_count = check_winner(root.send(link.to_sym), link, counter+1)
          @winner = true if total_count >= 4
        end
      end
    else
      check_winner(root.send(direction.to_sym), direction, counter+1)
    end
  end

end


class Game
  attr_accessor :game, :player1, :player2
  def initialize(player1=Player.new("0"), player2 = Player.new("X"))
    @cage = Cage.new
    @player1 = player1
    @player2 = player2
  end

  def winner_check
    return true if @player1.winner == true || @player2.winner == true
    false
  end

  def start_game
    play_game
  end

  private

  def play_game
    player1_turn = true
    until winner_check do
      puts @cage.display_cage
      if player1_turn
        player1_turn = false if player_turn(@player1)
      else
        player1_turn = true if player_turn(@player2)
      end
    end
    game_over
  end

  def player_turn(player)
    choice = player.player_move
    if !choice
      puts "Try again"
      return choice
    end
    player.get_icon_location(@cage, choice)
  end

  def game_over
    puts @cage.display_cage
    if player1.winner
      puts "Player 1 is the winner!"
    elsif player2.winner
      puts "Player 2 is the winner!"
    end
  end
end

# game = Game.new
# game.start_game