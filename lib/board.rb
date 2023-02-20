class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { |_| Array.new(8, nil) }
  end

  def set_pieces
    [1, 6].each_with_index do |row, team|
      8.times do |column|
        grid[row][column] = Pawn.new(team, self)
      end
    end
    [0, 7].each_with_index do |row, team|
      grid[row][4] = King.new(team, self)
      grid[row][3] = Queen.new(team, self)
      2.times do |column|
        grid[row][0 - column] = Rook.new(team, self)
        grid[row][1 - (column * 3)] = Knight.new(team, self)
        grid[row][2 - (column * 5)] = Bishop.new(team, self)
      end
    end
    grid[3][3] = Queen.new(0, self)
    grid[3][1] = Knight.new(0, self)
    grid[2][1] = Pawn.new(1, self)
    grid[2][3] = Pawn.new(1, self)
    grid[2][2] = Queen.new(0, self)
  end

  def print_board(walkables = [])
    grid.to_enum.with_index.reverse_each do |row, row_idx|
      print((row_idx + 1).to_s)
      row.each_with_index do |square, column_idx|
        string = "#{get_unicode(square)}#{walkables.include?([row_idx, column_idx]) ? '•' : ' '}"
        if (row_idx + column_idx).even?
          print(string.bg_gray)
        else
          print(string.bg_green)
        end
      end
      print("\n")
    end
    print(" a b c d e f g h \n")
  end

  def get_unicode(square)
    case square
    when Piece
      square.unicode
    else
      ' '
    end
  end

  def locate_piece(piece)
    8.times do |row|
      column = grid[row].index(piece)
      return [row, column] unless column.nil?
    end
  end

  def out_of_bounds?(array)
    return true unless array.all? { |pos| pos.between?(0, 7) }
  end

  def letter_to_num(letter)
    ('a'..'h').zip(0..7).to_h[letter]
  end

  def piece_select(team)
    squares = []
    (1..8).each_with_index do |number, row|
      ('a'..'h').each_with_index do |letter, column|
        next if grid[row][column].nil?

        squares << "#{letter}#{number}" if grid[row][column].team == team
      end
    end
    p squares
    user_input = 0
    user_input = gets.chomp until squares.include?(user_input)
    [user_input[1].to_i - 1, letter_to_num(user_input[0])]
  end

  def directional_moves(piece, directions)
    moves = []
    location = locate_piece(piece)
    directions.each do |direction|
      (1..7).each do |steps|
        move = [location.first + direction.first * steps, location.last + direction.last * steps]
        break if out_of_bounds?(move)

        potential_pos = grid[move.first][move.last]
        if potential_pos.nil?
          moves << move
        elsif potential_pos.team != piece.team
          moves << move
          break
        elsif potential_pos.team == piece.team
          break
        end
      end
    end
    moves
  end

  def knight_moves(piece)
    moves = []
    location = locate_piece(piece)
    piece.class::KNIGHT_MOVES.each do |direction|
      move = [location.first + direction.first, location.last + direction.last]
      next if out_of_bounds?(move)

      potential_pos = grid[move.first][move.last]
      moves << move if potential_pos.nil? || potential_pos.team != piece.team
    end
    moves
  end

  def pawn_moves(piece)
    moves = []
    location = locate_piece(piece)
    team = piece.team
    [1, -1].each_with_index do |vert_direction, idx|
      next unless idx == team

      if location.first == 1 || location.first == 6
        moves << [location.first + vert_direction * 2, location.last]
      end
      [1, -1].each do |hor_directoin|
        move_attack = [location.first + vert_direction * 1, location.last + hor_directoin]
        next if out_of_bounds?(move_attack)

        potential_pos = grid[move_attack.first][move_attack.last]
        next if potential_pos.nil?

        moves << move_attack if potential_pos.team != piece.team
      end
      move_forward = [location.first + vert_direction * 1, location.last]
      break if out_of_bounds?(move_forward)

      moves << move_forward if grid[move_forward.first][move_forward.last].nil?
    end
    moves
  end
end

# function to find moves horizontally, vertically and diagonally
# args are (piece, directions), directions is an array of arrays: [vertical, horizontal]
# [-1 for down / 1 for up, -1 for left / 1 for right]
# 0 to keep each respecive position

# PAWN

# args(team)
# moves = []
# location = locate_piece(piece)
# if team == 0
#   if location.first == 1
#     moves << [location.first + 2, location.last]
#   end
#   [-1, 1].each do |direction|
#     move = [location.first + 1, location.last + direction]
#     next if out_of_bounds?(move)
#
#     potential_pos = grid[move.first][move.last]
#     return if potential_pos.nil?
#
#     moves << move if potential_pos.team != piece.team
#   end
#   move_forward = [location.first + 1, location.last]
#   moves << move_forward unless out_of_bounds?(move_forward)

# args(team)
# moves = []
# location = locate_piece(piece)
# [1, -1].each_with_index do |vert_direction, idx|
#   next unless idx == team
#
#   if location.first == 1 || location.first == 6
#     moves << [location.fist + vert_direction * 2, location.last]
#   end
#   [1, -1].each do |hor_directoin|
#     move_attack = [location.first + vert_direction * 1, location.last + hor_directoin]
#     next if out_of_bounds?(move_attack)
#
#     potential_pos = grid[move_attack.fisrt][move_attack.last]
#     return if potential_pos.nil?
#
#     moves << move_attack if potential_pos.team != piece.team
#   end
#   move_forward = [location.first + vert_direction * 1, location.last]
#   moves << move_forward unless out_of_bounds?(move_forward)
# end
# moves

#   if (location.first == 6 && team == 1) || (location.first == 1 && team == 0)
#     moves << team == 1 ? [location.first - 2, location.last] : [location.first + 2, location.last]
#   end
#   [-1, 1].each do |direction|
#     move = team == 1 ? [location.first - 1, location.last + direction] : [location.first + 1, location.last + direction]
#     next if out_of_bounds?(move)
#
#     potential_pos = grid[move.first][move.last]
#     return if potential_pos.nil?
#
#     moves << move if potential_pos.team != piece.team
#   end
#   move_forward = team == 1 ? [location.first - 1, location.last] : [location.first + 1, location.last]
#   moves << move_forward unless out_of_bounds?(move_forward)

# calculate the possible moves of a selected piece
# find spots availabe for travel
# display travelable spots on the board
# ask for input and break if it is included with travelable spots
# or reselect the figure if the input was 'reselect'
# return the input and place the piece at that location on the grid,
# removing it from it's current position

# game loop:

# ask for a piece to select
# ask for a square to place the piece to
# make sure save and reselect are an option
# change player turns
