defmodule Aoc2024Elixir.D08 do
  def run() do
    parse_map("lib/aoc_2024_elixir/d08/test1.txt") |> solve_part_1() |> IO.inspect(label: "test1")
    parse_map("lib/aoc_2024_elixir/d08/input.txt") |> solve_part_1() |> IO.inspect(label: "input")
  end

  def parse_map(path) do
    map_rows = File.read!(path) |> String.split("\n", trim: true)
    n_rows = length(map_rows)
    n_cols = String.length(hd(map_rows))

    map =
      map_rows
      |> Enum.with_index(fn row, i -> parse_row(row, i) end)
      |> Enum.reduce(%{}, fn parsed_row, acc ->
        Map.merge(parsed_row, acc, fn _char, points_1, points_2 -> points_1 ++ points_2 end)
      end)

    {map, n_rows, n_cols}
  end

  def parse_row(row, row_index) do
    row
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn
      {".", _}, acc ->
        acc

      {char, col_index}, acc ->
        points = Map.get(acc, char, [])
        Map.put(acc, char, [{row_index, col_index} | points])
    end)
  end

  def solve_part_1({map, n_rows, n_cols}) do
    map
    |> Enum.flat_map(fn {_char, points} -> calc_antinodes(points) end)
    |> Enum.filter(fn {i, j} -> i >= 0 and i < n_rows and j >= 0 and j < n_cols end)
    |> Enum.uniq()
    |> length()
  end

  def solve_part_2({map, n_rows, n_cols}) do
    map
    |> Enum.flat_map(fn {_char, points} -> calc_antinodes(points) end)
    |> Enum.filter(fn {i, j} -> i >= 0 and i < n_rows and j >= 0 and j < n_cols end)
    |> Enum.uniq()
    |> length()
  end

  def calc_antinodes(points) when is_list(points) do
    Enum.flat_map(points, fn point_1 ->
      remaining = List.delete(points, point_1)

      Enum.map(remaining, fn point_2 ->
        calc_antinode(point_1, point_2)
      end)
    end)
  end

  def calc_antinode({i1, j1}, {i2, j2}) do
    dist_i = i2 - i1
    dist_j = j2 - j1
    new_i = i2 + dist_i
    new_j = j2 + dist_j

    {new_i, new_j}
  end
end
