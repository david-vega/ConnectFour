class Board
  attr_reader :matrix

  SIZE = { columns: 6, rows: 5 }.freeze
  LINE_SIZE = 4.freeze

  def initialize
    @matrix = Array.new(SIZE[:columns]){ Array.new(SIZE[:rows]) }
  end

  def add_chip(color:, column_number:)
    return false unless @matrix[column_number].compact.length < SIZE[:rows]
    number_of_elements = @matrix[column_number].compact.size
    @matrix[column_number][(SIZE[:rows] - 1) - number_of_elements] = color
  end

  def line?(color:)
    vertically?(color: color) ||
      horizontally?(color: color) ||
      diagonally?(color: color)
  end

  def full?
    !@matrix.flatten.any?{ |element| element.nil? }
  end

  private

  def vertically?(color:)
    in_line?(matrix: @matrix, color: color)
  end

  def horizontally?(color:)
    in_line?(matrix: @matrix.transpose, color: color)
  end

  def diagonally?(color:)
    in_line?(matrix: find_diagonal(matrix: @matrix), color: color) ||
      in_line?(matrix: find_diagonal(matrix: @matrix.reverse), color: color)
  end

  def find_diagonal(matrix:)
    padding = matrix.size - 1

    matrix.inject([]) do |padded_matrix, row|
      inverse_padding = matrix.size - padding
      padded_matrix << ([nil] * inverse_padding) + row + ([nil] * padding)
      padding -= 1

      padded_matrix
    end.transpose.map(&:compact).reject{ |array| array.size < LINE_SIZE }
  end

  def in_line?(matrix:, color:)
    matrix.select do |column|
      column.slice_when { |a,b| a != b }.any? { |array| array.include?(color) && array.size >= LINE_SIZE }
    end.flatten.any?
  end
end
