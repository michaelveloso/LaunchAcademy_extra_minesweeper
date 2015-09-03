require 'pry'
require_relative 'cell'

class Minefield
  attr_reader :row_count, :column_count

  def initialize(row_count, column_count, mine_count)
    @column_count = column_count
    @row_count = row_count
    @board = make_board(row_count, column_count)
    add_mines(mine_count)
  end

  # Return true if the cell been uncovered, false otherwise.
  def cell_cleared?(row, col)
    @board[row][col].cleared
  end

  # Uncover the given cell. If there are no adjacent mines to this cell
  # it should also clear any adjacent cells as well. This is the action
  # when the player clicks on the cell.
  def clear(row, col)
    @board[row][col].cleared = true
    if !contains_mine?(row, col)
      if adjacent_mines(row, col) == 0
        range = [-1, 0, 1]
        range.each do |range_x|
          range.each do |range_y|
            x_adj = row + range_x
            y_adj = col + range_y
            if cell_exists?(x_adj,y_adj)
              clear_cell(x_adj,y_adj)
            end
          end
        end
      end
    end
  end

  # Check if any cells have been uncovered that also contained a mine. This is
  # the condition used to see if the player has lost the game.
  def any_mines_detonated?
    row_count.times do |row|
      column_count.times do |col|
        return true if cell_cleared?(row, col) && contains_mine?(row, col)
      end
    end
    false
  end

  # Check if all cells that don't have mines have been uncovered. This is the
  # condition used to see if the player has won the game.
  def all_cells_cleared?
    row_count.times do |row|
      column_count.times do |col|
        return false unless cell_cleared?(row, col) && !contains_mine?(row, col)
      end
    end
    true
  end

  # Returns the number of mines that are surrounding this cell (maximum of 8).
  def adjacent_mines(row, col)
    mines_nearby = 0
    range = [-1, 0, 1]
    range.each do |range_x|
      range.each do |range_y|
        x_adj = row + range_x
        y_adj = col + range_y
        if cell_exists?(x_adj,y_adj)
          mines_nearby += 1 if contains_mine?(x_adj, y_adj)
        end
      end
    end
    mines_nearby
  end

  # Returns true if the given cell contains a mine, false otherwise.
  def contains_mine?(row, col)
    @board[row][col].mined
  end

  def make_board(row_count, column_count)
    board = []
    row_count.times do
      row = []
        column_count.times do
          row << Cell.new
        end
      board << row
    end
    board
  end

  def add_mines(mine_count)
    while mine_count > 0
      row = rand(20)
      column = rand(20)
      if not contains_mine?(row, column)
        @board[row][column].mined = true
        mine_count -= 1
      end
    end
  end

  def clear_cell(row, col)
    @board[row][col].cleared = true
  end

  def cell_exists?(row, col)
    row >= 0 && col >= 0 && row < row_count && col < column_count
  end

end
