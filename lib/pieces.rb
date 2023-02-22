class Piece
  attr_reader :team, :board

  def initialize(team, board)
    @team = team
    @board = board
  end

  def out_of_bounds?(array)
    return true unless array.all? { |pos| pos.between?(0, 7) }
  end

  def location
    8.times do |row|
      column = board.grid[row].index(self)
      return [row, column] unless column.nil?
    end
  end

  def add_arrays(array1, array2)
    array1.zip(array2).map(&:sum)
  end
end

# adds function to find moves in specified directions
module DirectionalMoves
  def moves
    moves = []
    self.class::DIRECTIONS.each do |direction|
      (1..7).each do |steps|
        move = add_arrays(location, [direction[0] * steps, direction[-1] * steps])
        break if out_of_bounds?(move)

        potential_pos = board[move]
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
  def moves
    moves = []
    [1, -1].each_with_index do |vert_direction, idx|
      next unless idx == team

      [1, 2].each do |steps|
        move_forward = add_arrays(location, [vert_direction * steps, 0])
        break if out_of_bounds?(move_forward)

        break unless board[move_forward].nil?

        moves << move_forward
        break unless location.first == 1 || location.first == 6
      end
      [1, -1].each do |hor_direction|
        move_attack = add_arrays(location, [vert_direction, hor_direction])
        next if out_of_bounds?(move_attack)

        potential_pos = board[move_attack]
        next if potential_pos.nil?

        moves << move_attack unless potential_pos.team == team
      end
    end
    moves
  end

  def unicode
    team.zero? ? '♙' : '♟︎'
  end
end

class Bishop < Piece
  include DirectionalMoves
  DIRECTIONS = [[1, 1], [-1, 1], [-1, -1], [1, -1]].freeze

  def unicode
    team.zero? ? '♗' : '♝'
  end
end

class Knight < Piece
  KNIGHT_MOVES = [[2, 1], [1, 2], [-1, 2], [-2, 1], [-2, -1], [-1, -2], [1, -2], [2, -1]].freeze

  def moves
    moves = []
    KNIGHT_MOVES.each do |direction|
      move = add_arrays(location, direction)
      next if out_of_bounds?(move)

      potential_pos = board[move]
      moves << move if potential_pos.nil? || potential_pos.team != team
    end
    moves
  end

  def unicode
    team.zero? ? '♘' : '♞'
  end
end

class Rook < Piece
  include DirectionalMoves
  DIRECTIONS = [[1, 0], [0, 1], [-1, 0], [0, -1]].freeze

  def unicode
    team.zero? ? '♖' : '♜'
  end
end

class Queen < Piece
  include DirectionalMoves
  DIRECTIONS = [[1, 0], [0, 1], [-1, 0], [0, -1], [1, 1], [-1, 1], [-1, -1], [1, -1]].freeze

  def unicode
    team.zero? ? '♕' : '♛'
  end
end

class King < Piece
  KING_MOVES = [[1, 0], [0, 1], [-1, 0], [0, -1], [1, 1], [-1, 1], [-1, -1], [1, -1]].freeze

  def moves
    moves = []
    KING_MOVES.each do |direction|
      move = add_arrays(location, direction)
      next if out_of_bounds?(move)

      potential_pos = board[move]
      moves << move if potential_pos.nil? || potential_pos.team != team
    end
    moves
  end

  def unicode
    team.zero? ? '♔' : '♚'
  end
end