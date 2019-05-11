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

  test "row indexes" do
    assert(Sudoku.same_row_indexes({ 4, 2 }) == [
      { 4, 0 }, { 4, 1 }, { 4, 3 }, { 4, 4 }, { 4, 5 }, { 4, 6 }, { 4, 7 }, { 4, 8 }
    ])

    assert(Sudoku.same_row_indexes({ 7, 1 }) == [
      { 7, 0 }, { 7, 2 }, { 7, 3 }, { 7, 4 }, { 7, 5 }, { 7, 6 }, { 7, 7 }, { 7, 8 }
    ])
  end

  test "column indexes" do
    assert(Sudoku.same_column_indexes({ 4, 2 }) == [
      { 0, 2 }, { 1, 2 }, { 2, 2 }, { 3, 2 }, { 5, 2 }, { 6, 2 }, { 7, 2 }, { 8, 2 }
    ])
  end

  test "box indexes" do
    assert(Sudoku.same_box_indexes({ 4, 2 }) == [
      { 3, 0 }, { 3, 1 }, { 3, 2 }, { 4, 0 }, { 4, 1 }, { 5, 0 }, { 5, 1 }, { 5, 2 }
    ])
  end

  test "process constraints" do
    data = """
    8 . . . . 5 3 7 2
    . . . . 8 6 . 9 .
    . 3 . 2 . . 8 . .
    5 6 . . . 4 1 3 9
    . . . . 6 . . . .
    3 4 7 9 . . . 6 5
    . . 1 . . 7 . 2 .
    . 2 . 6 5 . . . .
    5 7 9 8 . . . . 4
"""    
    things_to_write_in_2_8 = Sudoku.build_from_data(data)
                             |> Sudoku.process_constraints_at({ 1, 8 })

    assert(things_to_write_in_2_8 == MapSet.new([1]))
  end

  test "process all constraints" do
    data = """
    8 . . . . 5 3 7 2
    . . . . 8 6 . 9 .
    . 3 . 2 . . 8 . .
    5 6 . . . 4 1 3 9
    . . . . 6 . . . .
    3 4 7 9 . . . 6 5
    . . 1 . . 7 . 2 .
    . 2 . 6 5 . . . .
    5 7 9 8 . . . . 4
"""    
    Sudoku.build_from_data(data)
    |> Sudoku.process_all_constraints
    |> Sudoku.print
  end
end
