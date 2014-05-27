############################################################
#
#  Name:        Sean Glover
#  Assignment:  Word Search program
#  Date:        06/13/2013
#  Class:       CIS 283
#  Description: Generate word search puzzle and print to pdf
#
############################################################
require 'prawn'

class Puzzle

  def initialize(words_array)
    @key_array = []
    @temp_key_array = []
    @words_array = words_array
    @puzzle_array = []
=begin
1 = Horizontal
2 = Vertical
3 = Diagonal Right
4 = Diagonal Left
5 = Horizontal Reverse
6 = Vertical Reverse
7 = Diagonal Right Reverse
8 = Diagonal Left Reverse
=end
    # Final @directions array
    @directions = [1, 2, 3, 4, 5, 6, 7, 8]
    # Temp @directions array for testing
    #@directions = [1, 2, 3, 4]
  end

  # method to initialize arrays
  def initialize_arrays
    init_temp(@temp_key_array)

    45.times do |row|
      @key_array[row] = []
      45.times do
        @key_array[row] << "."
      end
    end
  end

  # method to build puzzle
  def build_puzzle
    self.initialize_arrays
    @words_array.each do |word|

      current_word = word

      placed_main = false

      while placed_main == false

        test_cell(current_word, @directions, @temp_key_array)

        placed_main = check_main(@temp_key_array, @key_array)

        init_temp(@temp_key_array)
      end
    end

    #ret_str = generate_puzzle(@key_array)
    ret_str = generate_puzzle
    return ret_str
    #return #puzzle_array = generate_puzzle(@key_array)
  end

  # method to selection word direction in puzzle
  def sel_direction(directions)
    return rand(1..directions.length)
  end

  # method to select starting cell
  def sel_cell(min, max)
    return rand(min..max)
  end

  # method to insert letter in temp array after validation
  def insert_letter(coord, current_word, temp_array, row_val, col_val)
    temp = current_word.split("")
    row = coord[0]
    col = coord[1]

    valid = true
    temp.each do |letter|
      if temp_array[row][col] == "x" or (temp_array[row][col] != letter and temp_array[row][col] != ".")
        valid = false
      end
      col += col_val
      row += row_val
    end

    if valid == true
      row = coord[0]
      col = coord[1]

      temp.each do |letter|
        temp_array[row][col] = letter
        col += col_val
        row += row_val
      end
    end

    return valid
  end

  # method to check main puzzle array if word can fit
  def check_main(temp_array, key_array)
    valid = true
    row = 0
    while row < temp_array.length
      col = 0
      while col < temp_array[row].length
        if temp_array[row][col] != "x" and temp_array[row][col] != "."

          if key_array[row][col] != "." and key_array[row][col] != temp_array[row][col]
            valid = false
          end
        end
        col += 1
      end
      row += 1
    end

    if valid == true
      temp_array.each_with_index do |row, index1|
        row.each_with_index do |col, index2|
          if col != "x" and col != "."
            key_array[index1][index2] = col
          end
        end
      end
    end

    return valid
  end

  # method for initializing the temp array after each word has been placed
  def init_temp(temp_array)
    temp_array.clear

    45.times do |row|
      temp_array[row] = []
      45.times do
        temp_array[row] << "."
      end
    end
  end

  # generate the actual puzzle and populate with only letters contained in all search words
  def generate_puzzle
    letter_array = []
    @key_array.each do |row|
      row.each do |col|
        if letter_array.include?(col) == false
          letter_array << col
        end
      end
    end

    letter_array.delete(".")

    @puzzle_array = []

    @key_array.each_with_index do |row, index|
      value = Array.new
      row.each do |col|
        if col == "."
          value << letter_array[rand(1..letter_array.length) - 1]
        else
          value << col
        end
      end
      @puzzle_array << value
    end

    ret_str = ""

    @puzzle_array.each do |row|
      ret_str += row.join(' ')
      ret_str += "\n"
    end
    ret_str += "\n\n"

    return ret_str
  end

  # method loop for testing cell for placement
  def test_cell(current_word, directions, temp_key_array)
    placed_temp = false

    while placed_temp != true
      direction = sel_direction(directions)

      coord = []
      if direction == 1
        min_row, max_row, min_col, max_col = 0, (temp_key_array.length - 1), 0, (temp_key_array.length - current_word.length)
        inc_row, inc_col = 0, 1

      elsif direction == 2
        min_row, max_row, min_col, max_col = 0, (temp_key_array.length - current_word.length), 0, (temp_key_array.length - 1)
        inc_row, inc_col = 1, 0

      elsif direction == 3
        min_row, max_row, min_col, max_col = 0, (temp_key_array.length - current_word.length), 0, (temp_key_array.length - current_word.length)
        inc_row, inc_col = 1, 1

      elsif direction == 4
        min_row, max_row, min_col, max_col = (current_word.length - 1), (temp_key_array.length - 1), 0, (temp_key_array.length - current_word.length)
        inc_row, inc_col = -1, 1

      elsif direction == 5
        min_row, max_row, min_col, max_col = 0, (temp_key_array.length - 1), (current_word.length - 1), (temp_key_array.length - 1)
        inc_row, inc_col = 0, -1

      elsif direction == 6
        min_row, max_row, min_col, max_col = (current_word.length - 1), (temp_key_array.length - 1), 0, (temp_key_array.length - 1)
        inc_row, inc_col = -1, 0

      elsif direction == 7
        min_row, max_row, min_col, max_col = (current_word.length - 1), (temp_key_array.length - 1), (current_word.length - 1), (temp_key_array.length - 1)
        inc_row, inc_col = -1, -1

      else
        min_row, max_row, min_col, max_col = 0, (temp_key_array.length - current_word.length), (current_word.length - 1), (temp_key_array.length - 1)
        inc_row, inc_col = 1, -1
      end

      coord[0], coord[1] = sel_cell(min_row, max_row), sel_cell(min_col, max_col)
      placed_temp = insert_letter(coord, current_word, temp_key_array, inc_row, inc_col)
    end
  end

  # method for printing the key
  def print_key
    ret_str = ""
    @key_array.each do |row|
      ret_str += row.join(' ')
      ret_str += "\n"
    end

    return ret_str
  end
end

words_array = []

# open file and initialize hash
words_file = File.open("words.txt")

# loop through file for hash population
while ! words_file.eof?
  # read each line from file
  word = words_file.gets.chomp
  word = word.gsub(/\s+/, "")
  # populate words_array with values from file
  words_array << word.upcase
end

# close file
words_file.close

#words_array = words_array.sort_by{|x|x.length}.reverse
#words_array.sort_by!{|x|x.length}
#words_array = words_array.sort{|x,y| y.length <=> x.length}
words_array.sort!{|x,y| y.length <=> x.length}

puzzle = Puzzle.new(words_array)

Prawn::Document.generate("puzzle.pdf") do |pdf|
  pdf.font "Courier"

  def print_page(header, header_x_coord, words_array, pdf, print_puzzle)
    # set font size for header
    pdf.font_size 24
    pdf.move_down(10)

    # print header text box
    pdf.text_box header,
                 :at => [header_x_coord, 720]

    # set font size for puzzle
    pdf.font_size 10

    # set position of puzzle
    pdf.move_down(20)
    # call build method on puzzle object
    #pdf.text puzzle.build_puzzle
    pdf.text print_puzzle

    # print header of words to find
    pdf.text_box "Find the following 45 words:",
                 :at => [170, 200]

    # print list of words to find
    pdf.move_down(10)
    # need to sort to list words alphabetically
    words_array.sort!

    pdf.column_box([50, 180], :columns => 3, :width => 500, :height => 160) do
      words_array.each do |word|
        pdf.text word
      end
    end
  end

  # store built puzzle in variable to pass to method for printing pdf doc
  print_puzzle = puzzle.build_puzzle
  # print first page containing word search puzzle
  print_page('Word Search', 180, words_array, pdf, print_puzzle)

  # jump to next page
  pdf.start_new_page

  # store built key in variable to pass to method for printing pdf
  print_puzzle = puzzle.print_key
  # print second page containing word search key
  print_page('Word Search Key', 150, words_array, pdf, print_puzzle)
end