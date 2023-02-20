require_relative 'board'

class Game
  attr_accessor :board

  def initialize
    @board = Board.new
  end

  def play
    board.set_pieces
    board.print_board
    player_turn
  end

  def player_turn
    location = board.piece_select(0)
    selected_piece = board.grid[location.first][location.last]
    puts "You selected a piece of type #{selected_piece.class}"
    walkables = board.directional_moves(selected_piece, selected_piece.class::DIRECTIONS)
    board.print_board(walkables)
  end
end
