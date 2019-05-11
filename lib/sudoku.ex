defmodule Sudoku do
  @doc """
  Takes a file name and builds a sudoku board
  from the contents of the file
  Example file format:
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
  def build_from_data(input_file_data) do
    input_file_data
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split/1)
    |> Enum.filter(fn x -> !Enum.empty?(x) end)
    |> Enum.flat_map(fn x -> x end)
    |> Enum.with_index
    |> Enum.filter(fn { val, _index } -> val != "." end)
    |> Enum.map(fn { val, index } -> {
      { div(index, 9), rem(index, 9) },
      MapSet.new([String.to_integer(val)])
    }
    end)
    |> Map.new
    |> fill_blanks
  end

  def fill_blanks(game) do
    for i <- 0..8 do
      for j <- 0..8 do
        { { i, j }, Sudoku.get(game, { i, j }) }
      end
    end
    |> Enum.flat_map(fn x -> x end)
    |> Map.new
  end

  @doc """
    takes a JSON in and builds a sudoku board
  """
  def build_from_json(%{ "squares" => squares_list }) do
    squares_list
    |> Enum.map(fn %{ "x" => x, "y" => y, "value" => v} ->
      { { y, x }, MapSet.new([v]) }
    end)
    |> Map.new
  end

  def get(game, index) do
    Map.get(game, index, MapSet.new([1, 2, 3, 4, 5, 6, 7, 8, 9]))
  end

  def same_column_indexes({ row, col }) do
    0..8
    |> Enum.to_list
    |> List.delete(row)
    |> Enum.map(fn i -> { i, col } end)
  end

  def same_row_indexes({ row, col }) do
    0..8
    |> Enum.to_list
    |> List.delete(col)
    |> Enum.map(fn i -> { row, i } end)
  end

  def same_box_indexes({ row, col }) do
    for i <- 0..2 do
      for j <- 0..2 do
        { (div(row, 3) * 3) + i, (div(col, 3) * 3) + j }
      end
    end
    |> Enum.flat_map(fn x -> x end)
    |> Enum.filter(fn { i, j } -> { i, j } != { row, col } end)
  end

  def process_constraints_at(game, index) do
    constraint_indexes = [
      same_row_indexes(index),
      same_column_indexes(index),
      same_box_indexes(index),
    ]
    |> Enum.reduce(&Enum.concat/2)

    constraint_values = Map.take(game, constraint_indexes)
                        |> Map.values
                        |> Enum.filter(fn v -> MapSet.size(v) == 1 end)
                        |> Enum.reduce(MapSet.new([]), &MapSet.union/2)

    MapSet.difference(
      Sudoku.get(game, index),
      constraint_values
    )
  end

  def process_constraints(game) do
    game
    |> Enum.map(fn { index, _ } ->
      { index, process_constraints_at(game, index) }
    end)
    |> Map.new
  end

  def process_all_constraints(game) do
    newgame = process_constraints(game)
    if newgame == game do
      newgame
    else
      process_all_constraints(newgame)
    end
  end

  def print(game) do
    for i <- 0..8 do
      for j <- 0..8 do
        v = Sudoku.get(game, {i, j})
        if MapSet.size(v) == 1 do
          " #{List.first(MapSet.to_list(v))} "
        else
          " . "
        end
      end
      |> IO.puts
    end
  end
end
