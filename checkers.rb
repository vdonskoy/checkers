class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) {Array.new(8)}
  end

  def [](pos)
      self.grid[pos[0]][pos[1]]
    end

    def []=(pos, piece)
      self.grid[pos[0]][pos[1]] = piece
    end

  def board_fill
    (0..7).each do |row|
      (0..7).each do |column|
        pos = [row,column]
        if row == 0 && column % 2 == 1
          self[pos] = Piece.new(pos,"white",self)
        elsif row == 1 && column % 2 == 0
          self[pos] = Piece.new(pos,"white",self)
        elsif row == 2 && column % 2 == 1
          self[pos] = Piece.new(pos,"white",self)
        elsif row == 5 && column % 2 == 0
          self[pos] = Piece.new(pos,"black",self)
        elsif row == 6 && column % 2 == 1
          self[pos] = Piece.new(pos,"black",self)
        elsif row == 7 && column % 2 == 0
          self[pos] = Piece.new(pos,"black",self)
        end
      end
    end
  end

  def contains_enemy_piece?(self_coord, target_coord)
    unless self[self_coord].nil? || self[target_coord].nil?
      return self[self_coord].color != self[target_coord].color
    end
    false
  end

  def contains_friendly_piece?(self_coord, target_coord)
    if self[self_coord] && self[target_coord]
      return self[self_coord].color == self[target_coord].color
    end
    false
  end

  def checkmate?(color)
    self.grid.each do |row|
      row.each do |space|
        unless space.nil?
          if space.color == color
            return false
          end
        end
      end
      true
    end
  end

  def render
    column_labels = {
      1 => "a",
      2 => "b",
      3 => "c",
      4 => "d",
      5 => "e",
      6 => "f",
      7 => "g",
      8 => "h"
    }

    row_labels = {
      1 => "8",
      2 => "7",
      3 => "6",
      4 => "5",
      5 => "4",
      6 => "3",
      7 => "2",
      8 => "1"
    }
    (0..9).each do |row|
      (0..9).each do |column|
        pos = [row-1,column-1]
        if row == 0 || row == 9
          if column_labels[column]
            print "#{column_labels[column]}"
          else
            print " "
          end
        elsif column == 0 || column == 9
          if row_labels[row]
            print "#{row_labels[row]}"
          else
            print " "
          end
        elsif self[pos] == nil && (row-1) % 2 != (column-1) % 2
          print "■"
        elsif self[pos] == nil
          print "□"
        elsif self[pos].color == "white" && self[pos].is_king == false
          print "☺"
        elsif self[pos].color == "black" && self[pos].is_king == false
          print "☻"
        elsif self[pos].color == "white" && self[pos].is_king == true
          print "♔"
        elsif self[pos].color == "black" && self[pos].is_king == true
          print "♚"
        end
      end
      puts
    end
  end
end

class Piece
  attr_accessor :pos, :color, :board, :is_king

  def initialize(pos,color,board)
    @pos = pos
    @color = color
    @board = board
    @is_king = false
  end

  def slide_moves
    possible_moves = []
    self.move_diffs.each do |delta|
      coords = @pos.dup
      coords[0] += delta[0]
      coords[1] += delta[1]
      if ((0..7).to_a.include?(coords[0]) && (0..7).to_a.include?(coords[1])) && @board[coords].nil?
        possible_moves << coords
      end
    end
    possible_moves
  end

  def jump_moves
    possible_moves = []
    self.move_diffs.each do |delta|
      coords = @pos.dup
      coords[0] += delta[0]
      coords[1] += delta[1]
      if @board.contains_enemy_piece?(self.pos,coords) && !@board.contains_enemy_piece?(self.pos,[coords[0]+delta[0],coords[1]+delta[1]])
        possible_moves << [coords[0]+delta[0],coords[1]+delta[1]]
      end
    end
    possible_moves
  end

  def move_diffs
    if @is_king
      deltas = [[1,-1],[1,1],[-1,-1],[-1,1]]
    elsif self.color == "white"
      deltas = [[1,-1],[1,1]]
    elsif self.color == "black"
      deltas =[[-1,-1],[-1,1]]
    end
    deltas
  end

  def perform_slide(pos, target_coords)
    #if self.slide_moves.include?(target_coords)
      self.board[target_coords] = self.board[pos].class.new(target_coords.dup, self.board[pos].color, self.board)
      self.board[pos] = nil
      self.maybe_promote
      #end
  end

  def perform_jump(pos, target_coords)
    #if self.jump_moves.include?(target_coords)
      self.board[target_coords] = self.board[pos].class.new(target_coords.dup, self.board[pos].color, self.board)
      self.board[pos] = nil
      self.delete_opponent(target_coords)
      self.maybe_promote
      #end
  end

  def perform_moves!(start_pos,end_pos)
    if self.slide_moves.include?(end_pos)
      perform_slide(start_pos,end_pos)
    elsif self.jump_moves.include?(end_pos)
      perform_jump(start_pos,end_pos)
    end
  end

  def delete_opponent(target_coords)
    opponent_coords = ((pos[0]+target_coords[0])/2),((pos[1]+target_coords[1])/2)
    self.board[opponent_coords] = nil
  end

  def maybe_promote
    if self.pos[0] == 0 && self.color == "black"
      @is_king = true
    elsif self.pos[0] == 7 && self.color == "white"
      @is_king = true
    end
  end
end

class Game
  def initialize
    @board = Board.new
    @board.board_fill
    self.play
  end

  def play
    turn = 1
    conversions = {
      "a" => 0,
      "b" => 1,
      "c" => 2,
      "d" => 3,
      "e" => 4,
      "f" => 5,
      "g" => 6,
      "h" => 7,
      "8" => 0,
      "7" => 1,
      "6" => 2,
      "5" => 3,
      "4" => 4,
      "3" => 5,
      "2" => 6,
      "1" => 7,
    }
    turn_colors = ["black","white"]
    turn_color = turn_colors[0]
    until @board.checkmate?(turn_color)
      @board.render
      turn_color = turn_colors[turn % 2]
      puts "#{turn_color.capitalize} turn"
      puts "Enter the coordinates of the piece you would like to move:"
      start_pos = gets.chomp.split("").reverse.map { |num| conversions[num] }
      if !@board[start_pos].nil? && @board[start_pos].color != turn_color
        puts "That is not your piece!"
        next
      end
      run = "y"
      until run == "n"
        puts "Enter the coordinates of the space you would like to move to:"
        end_pos = gets.chomp.split("").reverse.map { |num| conversions[num] }
        @board[start_pos].perform_moves!(start_pos,end_pos)
        puts "Would you like to move again?"
        run = gets.chomp
        start_pos = end_pos
      end
      turn += 1

    end
  end
end

Game.new