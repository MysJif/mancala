VERSION = "0.0.1"

def prompt(message) # Message prompt format
  puts "=> #{message}"
end

def board_init() # Initializes a new board array
  [4, 4, 4, 4, 4, 4, 0, 4, 4, 4, 4, 4, 4, 0]
end

def space_string(space) # Returns formatted space amounts for display
  if space > 9
    space
  else
    "#{space} "
  end
end

def display(board) # Displays the provided board array in ASCII
  puts "|   |[#{space_string(board[12])}][#{space_string(board[11])}][#{space_string(board[10])}][#{space_string(board[9])}][#{space_string(board[8])}][#{space_string(board[7])}]|   |"
  puts "| #{space_string(board[13])}|------------------------| #{space_string(board[6])}|"
  puts "|   |[#{space_string(board[0])}][#{space_string(board[1])}][#{space_string(board[2])}][#{space_string(board[3])}][#{space_string(board[4])}][#{space_string(board[5])}]|   |"
  puts "      A   B   C   D   E   F"
end

def move!(space, board, player) # Moves pieces around the board and determines if anything special happens.
  hand = board[space]
  count = space + 1
  board[space] = 0
  loop do
    board[count] += 1
    hand -= 1
    if hand == 0

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

def opposite(space) # Returns opposite space from the provided space
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

def again?(final_space, player) # Determines if the player goes again
  (final_space == 6 && player == 1) || (final_space == 13 && player == 2)
end

def jackpot_player?(final_space, board) # Determines if the player landed on a jackpot
  board[final_space] == 1 &&
    final_space < 6 &&
    board[opposite(final_space)] > 0
end

def jackpot_computer?(final_space, board) # Determines if the computer landed on a jackpot
  board[final_space] == 1 &&
    final_space > 6 &&
    final_space < 13 &&
    board[opposite(final_space)] > 1
end

def empty?(board) # Determines if either player has an empty side.
  (board[0] == 0 && board[1] == 0 && board[2] == 0 && board[3] == 0 && board[4] == 0 && board[5] == 0) ||
  (board[7] == 0 && board[8] == 0 && board[9] == 0 && board[10] == 0 && board[11] == 0 && board[12] == 0)
end

def end!(board) # Shuffles each side's pieces to their pockets
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

def winner!(board, score) # Displays scores, winner, and tallies up game wins
  system 'clear'
  prompt "Player: #{board[6]}"
  prompt "Computer: #{board[13]}"

  if board[6] > board[13]
    prompt "Player won!"
    score[0] += 1
  elsif board[13] > board[6]
    prompt "Computer won!"
    score[1] += 1
  else
    prompt "It's a Draw!"
  end

  prompt "Games won:"
  prompt "Player: #{score[0]} | Computer: #{score[1]}"
end

def empty_space?(space, board) # Determines if provided space is empty.
  board[space] < 1
end

def computer(board) # Decides computer's turn.
  space = 12
  puts "Computer logs."
  return if empty?(board)
  loop do # Detecting any Hole in One choices.
    puts space
    if board[space] == (13 - space)
      puts "Computer space is HIO. Space is #{space}"
      break
    else
      puts "Space not HIO. Space is #{space}"
      space -= 1
    end

    if space < 8 # Algorithm or Random Chance decision
      if [true, false].sample #Algorithm
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

prompt "Welcome to Mancala"
prompt "Version: #{VERSION}"
score = [0, 0]
loop do
  board = board_init()
  loop do
    loop do
      break if empty?(board)
      system 'clear'
      display(board)
      space = ''
      loop do
        prompt "Which space do you want to move?"
        space = gets.chomp.upcase


        case space
        when 'A'
          space = 0
          break unless empty_space?(space, board)
          prompt "Selected space empty."
        when 'B'
          space = 1
          break unless empty_space?(space, board)
          prompt "Selected space empty."
        when 'C'
          space = 2
          break unless empty_space?(space, board)
          prompt "Selected space empty."
        when 'D'
          space = 3
          break unless empty_space?(space, board)
          prompt "Selected space empty."
        when 'E'
          space = 4
          break unless empty_space?(space, board)
          prompt "Selected space empty."
        when 'F'
          space = 5
          break unless empty_space?(space, board)
          prompt "Selected space empty."
        else
          prompt "Invalid selection."
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

  prompt "Do you want to play again? (Y / N)"
  break unless gets.chomp.downcase == 'y'
end
