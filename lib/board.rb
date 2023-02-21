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

  def print_board(moves = [])
    grid.to_enum.with_index.reverse_each do |row, row_idx|
      print((row_idx + 1).to_s)
      row.each_with_index do |square, column_idx|
        string = "#{get_unicode(square)}#{moves.include?([row_idx, column_idx]) ? '•' : ' '}"
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
end

# function to find moves horizontally, vertically and diagonally
# args are (piece, directions), directions is an array of arrays: [vertical, horizontal]
# [-1 for down / 1 for up, -1 for left / 1 for right]
# 0 to keep each respecive position

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
