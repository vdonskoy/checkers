class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) {Array.new(8)}
  end

  def board_fill
    self.grid.each do |row|
      self.grid.each do |space|
        if row.index == 0 && space.index % 2 == 1
          space = Piece.new([row,space],"white")
        elsif row.index == 1 && space.index % 2 == 0
          space = Piece.new([row,space],"white")
        elsif row.index == 2 && space.index % 2 == 1
          space = Piece.new([row,space],"white")
        elsif row.index == 5 && space.index % 2 == 0
          space = Piece.new([row,space],"black")
        elsif row.index == 6 && space.index % 2 == 1
          space = Piece.new([row,space],"black")
        elsif row.index == 7 && space.index % 2 == 0
          space = Piece.new([row,space],"black")
        end
      end
    end
  end

  def render
    self.grid.each do |row|
      self.grid.each do |space|
        if space == nil && (row.index % 2 == 0 && space.index % 2 == 0) || (row.index % 2 == 1 && space.index % 2 == 1)
          print □
        elsif space == nil && (row.index % 2 == 0 && space.index % 2 == 1) || (row.index % 2 == 1 && space.index % 2 == 0)
          print ■
        elsif space.color == "white"
          print ☺
        elsif space.color == "black"
          print ☻
        end
      end
      puts
    end
  end
end

b = Board.new
b.render