class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { |_| Array.new(8, nil) }
  end

  def [](location)
    row, column = location
    grid[row][column]
  end

  def []=(location, data)
    row, column = location
    grid[row][column] = data
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

  def piece_select(team)
    squares = []
    (1..8).each_with_index do |number, row|
      ('a'..'h').each_with_index do |letter, column|
        next if self[[row, column]].nil?

        squares << "#{letter}#{number}" if self[[row, column]].team == team
      end
    end
    user_input = 0
    user_input = gets.chomp until squares.include?(user_input)
    piece = self[name_to_location(user_input)]
    puts "You selected a piece of type #{piece.class}"
    piece
  end

  def move_piece(piece, moves)
    squares = []
    moves.each do |move|
      squares << location_to_name(move)
    end
    user_input = 0
    user_input = gets.chomp until squares.include?(user_input)

    current_location = piece.location
    chosen_location = name_to_location(user_input)
    potential_pos = self[chosen_location]
    puts("You captured enemy #{potential_pos.class}") unless potential_pos.nil?
    if promote?(piece, chosen_location)
      promotions = %w[queen rook bishop knight]
      puts('Select promotion: Queen, Rook, Bishop or Knight')
      promotion = ''
      promotion = gets.chomp.downcase until promotions.include?(promotion)
      case promotion
      when 'queen'
        self[chosen_location] = Queen.new(piece.team, self)
      when 'rook'
        self[chosen_location] = Rook.new(piece.team, self)
      when 'bishop'
        self[chosen_location] = Bishop.new(piece.team, self)
      when 'knight'
        self[chosen_location] = Knight.new(piece.team, self)
      end
      self[current_location] = nil
      return
    end
    self[chosen_location] = piece
    self[current_location] = nil
  end

  def location_to_name(array)
    string = ''
    string += (0..7).zip('a'..'h').to_h[array.last]
    string + (array.first + 1).to_s
  end

  def name_to_location(string)
    array = []
    array << string[-1].to_i - 1
    array << ('a'..'h').zip(0..7).to_h[string[0]]
  end

  def promote?(piece, location)
    return unless piece.instance_of?(Pawn)

    return unless location.first == 0 || location.first == 7

    return true
  end
end