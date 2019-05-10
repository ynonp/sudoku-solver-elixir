defmodule SudokuTest do
  use ExUnit.Case
  doctest Sudoku

  test "build board from data file" do
    data = """
4 . . 8 . . 5 9 .
. 8 . . . 9 . . .
. . . 2 6 . . 4 .
. . 8 . . . . . 3
6 7 . . 5 . . 1 8
1 . . . . . 2 . .
. 6 . . 8 1 . . .
. . . 3 . . . 2 .
. 9 5 . . 7 . . 6
"""
    game = Sudoku.build_from_data(data)
    assert(Sudoku.get(game, { 0, 0 }) == MapSet.new([4]))
    assert(Sudoku.get(game, { 0, 3 }) == MapSet.new([8]))
    assert(Sudoku.get(game, { 0, 1 }) == MapSet.new([1, 2, 3, 4, 5, 6, 7, 8, 9]))
  end
end
