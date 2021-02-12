VERSION = '0.0.2'

# Message prompt format
def prompt(message)
  puts "=> #{message}"
end

# Initializes a new board array
def board_init
  [4, 4, 4, 4, 4, 4, 0, 4, 4, 4, 4, 4, 4, 0]
end

# Returns formatted space amounts for display
def space_string(space)
  if space > 9
    space
  else
    "#{space} "
  end
end

# Displays the provided board array in ASCII
def display(board)
  puts "|   |[#{space_string(board[12])}][#{space_string(board[11])}][#{space_string(board[10])}][#{space_string(board[9])}][#{space_string(board[8])}][#{space_string(board[7])}]|   |"
  puts "| #{space_string(board[13])}|------------------------| #{space_string(board[6])}|"
  puts "|   |[#{space_string(board[0])}][#{space_string(board[1])}][#{space_string(board[2])}][#{space_string(board[3])}][#{space_string(board[4])}][#{space_string(board[5])}]|   |"
  puts '      A   B   C   D   E   F'
end

# Moves pieces around the board and determines if anything special happens.
def move!(space, board, player)
  hand = board[space]
  count = space + 1
  board[space] = 0
  loop do
    board[count] += 1
    hand -= 1
    if hand.zero?

      break
    elsif count == 13
      count = 0
    else
      count += 1
    end
  end

  if empty?(board)
    return
  elsif jackpot_player?(count, board) && player == 1
    board[6] += board[count] + board[opposite(count)]
    board[count] = 0
    board[opposite(count)] = 0
  elsif jackpot_computer?(count, board) && player == 2
    board[13] += board[count] + board[opposite(count)]
    board[count] = 0
    board[opposite(count)] = 0
  end

  again?(count, player)
end

# Returns opposite space from the provided space
def opposite(space)
  case space
  when 0
    12
  when 1
    11
  when 2
    10
  when 3
    9
  when 4
    8
  when 5
    7
  when 7
    5
  when 8
    4
  when 9
    3
  when 10
    2
  when 11
    1
  when 12
    0
  end
end

# Determines if the player goes again
def again?(final_space, player)
  (final_space == 6 && player == 1) || (final_space == 13 && player == 2)
end

# Determines if the player landed on a jackpot
def jackpot_player?(final_space, board)
  board[final_space] == 1 &&
    final_space < 6 &&
    (board[opposite(final_space)]).positive?
end

# Determines if the computer landed on a jackpot
def jackpot_computer?(final_space, board)
  board[final_space] == 1 &&
    final_space > 6 &&
    final_space < 13 &&
    board[opposite(final_space)] > 1
end

# Determines if either player has an empty side.
def empty?(board)
  ((board[0]).zero? && (board[1]).zero? && (board[2]).zero? && (board[3]).zero? && (board[4]).zero? && (board[5]).zero?) ||
    ((board[7]).zero? && (board[8]).zero? && (board[9]).zero? && (board[10]).zero? && (board[11]).zero? && (board[12]).zero?)
end

# Shuffles each side's pieces to their pockets
def end!(board)
  count = 0
  pocket = 0
  loop do
    break if count == 14

    if count != 6 && count != 13
      pocket += board[count]
      board[count] = 0
    else
      board[count] += pocket
      pocket = 0
    end
    count += 1
  end
end

# Displays scores, winner, and tallies up game wins
def winner!(board, score)
  system 'clear'
  prompt "Player: #{board[6]}"
  prompt "Computer: #{board[13]}"

  if board[6] > board[13]
    prompt 'Player won!'
    score[0] += 1
  elsif board[13] > board[6]
    prompt 'Computer won!'
    score[1] += 1
  else
    prompt "It's a Draw!"
  end

  prompt 'Games won:'
  prompt "Player: #{score[0]} | Computer: #{score[1]}"
end

# Determines if provided space is empty.
def empty_space?(space, board)
  board[space] < 1
end

# Decides computer's turn.
def computer(board)
  space = 12
  return if empty?(board)

  loop do # Detecting any Hole in One choices.
    puts space
    if board[space] == (13 - space)
      break
    else
      space -= 1
    end

    if space < 8 # Algorithm or Random Chance decision
      if [true, false].sample # Algorithm
        space = 12
        loop do
          if space == 7
            break
          elsif empty_space?(space, board)
            space -= 1
          else
            break
          end
        end
        break
      else # Random Chance
        loop do
          space = rand(7..12)
          break unless empty_space?(space, board)
        end
      end
    end
  end
  space
end

prompt 'Welcome to Mancala'
prompt "Version: #{VERSION}"

score = [0, 0]

loop do
  board = board_init
  loop do
    loop do
      break if empty?(board)

      system 'clear'
      display(board)
      space = ''
      loop do
        prompt 'Which space do you want to move?'
        space = gets.chomp.upcase

        case space
        when 'A'
          space = 0
          break unless empty_space?(space, board)

          prompt 'Selected space empty.'
        when 'B'
          space = 1
          break unless empty_space?(space, board)

          prompt 'Selected space empty.'
        when 'C'
          space = 2
          break unless empty_space?(space, board)

          prompt 'Selected space empty.'
        when 'D'
          space = 3
          break unless empty_space?(space, board)

          prompt 'Selected space empty.'
        when 'E'
          space = 4
          break unless empty_space?(space, board)

          prompt 'Selected space empty.'
        when 'F'
          space = 5
          break unless empty_space?(space, board)

          prompt 'Selected space empty.'
        else
          prompt 'Invalid selection.'
        end
      end
      break unless move!(space, board, 1)
    end

    system 'clear'
    prompt "Computer's turn."
    loop do
      break if empty?(board)

      display(board)
      space = computer(board)
      break unless move!(space, board, 2)
    end
    break if empty?(board)
  end
  end!(board)
  winner!(board, score)

  prompt 'Do you want to play again? (Y / N)'
  break unless gets.chomp.downcase == 'y'
end
