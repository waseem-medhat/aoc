defmodule D08.Solver do
  def run() do
    IO.puts("PART1")
    parse_map("lib/d08/test1.txt") |> solve_part_1() |> IO.inspect(label: "test1")
    parse_map("lib/d08/input.txt") |> solve_part_1() |> IO.inspect(label: "input")

    IO.puts("\nPART2")
    parse_map("lib/d08/test1.txt") |> solve_part_2() |> IO.inspect(label: "test1")
    parse_map("lib/d08/input.txt") |> solve_part_2() |> IO.inspect(label: "input")

    :ok
  end

  @doc """
  Parses the map from the file in the given path.
  """
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

  @doc """
  Parses a single row (line) of the map. The row index is needed to form a
  {row, col} point when parsing.
  """
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

  @doc """
  Solves part 1 by calculating antinodes and counting their unique locations.
  """
  def solve_part_1({map, n_rows, n_cols}) do
    map
    |> Enum.filter(fn {_char, points} -> length(points) > 1 end)
    |> Enum.flat_map(fn {_char, points} -> calc_antinodes(points, n_rows, n_cols, false) end)
    |> Enum.uniq()
    |> length()
  end

  @doc """
  Solves part 1 by calculating antinodes and counting their unique locations,
  including antinode extensions and the antennas themselves.
  """
  def solve_part_2({map, n_rows, n_cols}) do
    map
    |> Enum.filter(fn {_char, points} -> length(points) > 1 end)
    |> Enum.flat_map(fn {_char, points} -> calc_antinodes(points, n_rows, n_cols, true) end)
    |> Enum.uniq()
    |> length()
  end

  @doc """
  Calculates all antinodes for a given list of points, assuming all points are
  for the same antenna frequencies.

  `n_rows` and `n_cols` are the maximum map dimensions, and `extend?` is a
  boolean to add the modifications necessary for solving part 2.
  """
  def calc_antinodes(points, n_rows, n_cols, extend?) do
    Enum.flat_map(points, fn point_1 ->
      remaining = List.delete(points, point_1)

      # in part 2, the points themselves are antinodes, so we can use them as
      # an initial accumulator
      init_acc = if extend?, do: points, else: []

      Enum.reduce(remaining, init_acc, fn point_2, antinodes ->
        {i1, j1} = point_1
        {i2, j2} = point_2

        dist_i = i2 - i1
        dist_j = j2 - j1

        new_i = i2 + dist_i
        new_j = j2 + dist_j

        cond do
          new_i < 0 -> antinodes
          new_j < 0 -> antinodes
          new_i >= n_rows -> antinodes
          new_j >= n_cols -> antinodes
          extend? -> extend_antinode({new_i, new_j}, dist_i, dist_j, n_rows, n_cols) ++ antinodes
          true -> [{new_i, new_j} | antinodes]
        end
      end)
    end)
  end

  @doc """
  For a given point and `i`/`j` distances, calculate all possible antinodes
  within the allowable map dimensions (`n_rows` and `n_cols`).
  """
  def extend_antinode(point, dist_i, dist_j, n_rows, n_cols),
    do: extend_antinode(point, dist_i, dist_j, n_rows, n_cols, [])

  def extend_antinode({i, j}, _dist_i, _dist_j, n_rows, n_cols, acc)
      when i < 0 or i >= n_rows or j < 0 or j >= n_cols,
      do: acc

  def extend_antinode({i, j}, dist_i, dist_j, n_rows, n_cols, acc) do
    new_i = i + dist_i
    new_j = j + dist_j

    extend_antinode({new_i, new_j}, dist_i, dist_j, n_rows, n_cols, [{i, j} | acc])
  end
end
