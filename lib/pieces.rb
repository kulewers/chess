class Piece
  attr_reader :team, :board

  def initialize(team, board)
    @team = team
    @board = board
  end

  def out_of_bounds?(array)
    return true unless array.all? { |pos| pos.between?(0, 7) }
  end

end

module DirectionalMoves
  def moves
    moves = []
    location = locate_piece(self)
    DIRECTIONS.each do |direction|
      (1..7).each do |steps|
        move = [location.first + direction.first * steps, location.last + direction.last * steps]
        break if out_of_bounds?(move)

        potential_pos = board.grid[move.first][move.last]
        if potential_pos.nil?
          moves << move
        elsif potential_pos.team != team
          moves << move
          break
        elsif potential_pos.team == team
          break
        end
      end
    end
    moves
  end
end

class Pawn < Piece
  def unicode
    team.zero? ? '♙' : '♟︎'
  end
end

class Bishop < Piece
  DIRECTIONS = [[1, 1], [-1, 1], [-1, -1], [1, -1]].freeze
  include DirectionalMoves

  def unicode
    team.zero? ? '♗' : '♝'
  end
end

class Knight < Piece
  KNIGHT_MOVES = [[2, 1], [1, 2], [-1, 2], [-2, 1], [-2, -1], [-1, -2], [1, -2], [2, -1]].freeze

  def unicode
    team.zero? ? '♘' : '♞'
  end
end

class Rook < Piece
  DIRECTIONS = [[1, 0], [0, 1], [-1, 0], [0, -1]].freeze
  include DirectionalMoves

  def unicode
    team.zero? ? '♖' : '♜'
  end
end

class Queen < Piece
  DIRECTIONS = [[1, 0], [0, 1], [-1, 0], [0, -1], [1, 1], [-1, 1], [-1, -1], [1, -1]].freeze
  include DirectionalMoves

  def unicode
    team.zero? ? '♕' : '♛'
  end
end

class King < Piece
  def unicode
    team.zero? ? '♔' : '♚'
  end
end