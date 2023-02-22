class Game
  attr_accessor :current_player_id
  attr_reader :board

  def initialize
    @board = Board.new

    @current_player_id = 0
  end

  def play
    board.set_pieces
    loop do
      puts "It's player #{current_player_id + 1}'s turn"
      enemy_king_pos = find_enemy_king
      if check(enemy_king_pos)
        puts "Player #{current_player_id + 1} won!"
        break
      end
      board.print_board
      moves = []
      selected_piece = nil
      loop do
        selected_piece = board.piece_select(current_player_id)
        moves = selected_piece.moves
        break if moves.size.positive?

        puts 'Piece has no available moves, please reselect'
      end
      board.print_board(moves)
      board.move_piece(selected_piece, moves)
      board.print_board
      change_player!
    end
  end

  def change_player!
    @current_player_id = 1 - current_player_id
  end

  def find_enemy_king
    8.times do |row|
      8.times do |column|
        figure = board[[row, column]]
        next if figure.nil?

        return [row, column] if figure.team != current_player_id && figure.instance_of?(King)
      end
    end
  end

  def check(king_pos)
    8.times do |row|
      8.times do |column|
        figure = board[[row, column]]
        next if figure.nil?

        return true if figure.moves.include?(king_pos)
      end
    end
    false
  end
end
