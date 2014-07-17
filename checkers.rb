class Game
  def initialize
    b = Board.new
    b.board_fill
    b.render
  end

  def play

  end
end

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) {Array.new(8)}
  end

  def [](pos)
      #raise RuntimeError.new("Please enter a valid position.") if pos.any? {|el| el.nil?}
      self.grid[pos[0]][pos[1]]
    end

    def []=(pos, piece)
      #raise RuntimeError.new("Please enter a valid position.") if pos.any? {|el| el.nil?}
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

  def render
    (0..7).each do |row|
      (0..7).each do |column|
        pos = [row,column]
        if self[pos] == nil && row % 2 != column % 2
          print "■"
        elsif self[pos] == nil
          print "□"
        elsif self[pos].color == "white"
          print "☺"
        elsif self[pos].color == "black"
          print "☻"
        end
      end
      puts
    end
  end
end

class Piece
  attr_accessor :pos, :color, :board

  def initialize(pos,color,board)
    @pos = pos
    @color = color
    @board = board
  end

  def moves
    possible_moves = []
    self.move_diffs.each do |delta|
      coords = @pos.dup
      coords[0] += delta[0]
      coords[1] += delta[1]
      if ((0..7).to_a.include?(coords[0]) && (0..7).to_a.include?(coords[1]))
        && @board[coords].nil?
        possible_moves << coords
      elsif @board.contains_enemy_piece?(self.pos,coords)
        && !@board.contains_enemy_piece?(self.pos,[coords[0]+delta[0],coords[1]+delta[1]])
        possible_moves << [coords[0]+delta[0],coords[1]+delta[1]]
      end
    end
    possible_moves
  end

  def move_diffs
    if piece.color == "white"
      deltas = [[-1,1],[1,1]]
    elsif piece.color == "black"
      deltas =[[-1,-1],[1,-1]]
    end
    deltas
  end

  def perform_slide

  end

  def perform_jump

  end

  def maybe_promote

  end

  def promote

  end
end