class SystemConsoleIO
  class GameIO
    COLORS = %w[red blue].freeze

    def initialize
      @board = Board.new
      @current_color = COLORS.first
    end

    def run
      print_board
      while true do
        get_column_position
        next unless add_chip_to_board?
        print_board
        break if line_or_full?
        switch_color
      end
      print_goodbye
    end

    private

    def get_column_position
      @column_number = -1
      puts "\n #{colorize(text: @current_color, color: @current_color)} turn, please input column number"

      while invalid_column?(column_number: @column_number)
        input = STDIN.gets.chomp.to_i - 1

        if invalid_column?(column_number: input)
          puts 'Invalid column number'.bold
          next
        end

        @column_number = input
      end
    end

    def add_chip_to_board?
      @board.add_chip(color: @current_color, column_number: @column_number)
    end

    def line_or_full?
      line? || @board.full?
    end

    def line?
      @board.line?(color: @current_color)
    end

    def switch_color
      @current_color = COLORS.select{|color| color != @current_color }.first
    end

    def invalid_column?(column_number:)
      !column_number.between?(0, Board::SIZE[:columns] - 1)
    end

    def print_board
      system 'clear'
      puts format_row(row: (1..Board::SIZE[:columns]).to_a).green
      flipped_board = @board.matrix.transpose
      Board::SIZE[:rows].times do |index|
        row = flipped_board[index].map{ |color| color ? colorize(text: '@', color: color) : 'O'.gray }
        puts format_row(row: row)
      end
    end

    def format_row(row:)
      " #{row.join("\t")}\n"
    end

    def colorize(text:, color:)
      text.send(color).bold
    end

    def print_goodbye
      if line?
        puts "\n\t#{colorize(text: @current_color, color: @current_color)} Wins !!"
      else
        puts "\n\tThere was no winner"
      end
    end
  end
end
