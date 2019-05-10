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
end
