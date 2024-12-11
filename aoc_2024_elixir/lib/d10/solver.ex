defmodule D10.Solver do
  def run do
    IO.puts("PART1")
    parse("lib/d10/test1.txt") |> solve_part_1() |> IO.inspect(label: "test1")
    parse("lib/d10/test2.txt") |> solve_part_1() |> IO.inspect(label: "test2")
    parse("lib/d10/test3.txt") |> solve_part_1() |> IO.inspect(label: "test3")
    parse("lib/d10/input.txt") |> solve_part_1() |> IO.inspect(label: "input")

    IO.puts("\nPART2")
    parse("lib/d10/test4.txt") |> solve_part_2() |> IO.inspect(label: "test4")
    parse("lib/d10/test1.txt") |> solve_part_2() |> IO.inspect(label: "test1")
    parse("lib/d10/test5.txt") |> solve_part_2() |> IO.inspect(label: "test5")
    parse("lib/d10/input.txt") |> solve_part_2() |> IO.inspect(label: "input")

    :ok
  end

  @doc """
  Parses the file in the given path into a map of `{i, j} => num` with an extra
  entry `:zero_locs` that stores the starting points in a list.
  """
  def parse(path) do
    File.read!(path) |> parse_map(0, 0, %{zero_locs: []})
  end

  @doc """
  Recursively parses the given map string.
  """
  def parse_map(string, i, j, acc)

  def parse_map("\n", _, _, acc), do: acc

  def parse_map("\n" <> rest, i, _j, acc), do: parse_map(rest, i + 1, 0, acc)

  def parse_map("0" <> rest, i, j, %{zero_locs: zero_locs} = acc) do
    acc =
      acc
      |> Map.put({i, j}, ?0)
      |> Map.put(:zero_locs, [{i, j} | zero_locs])

    parse_map(rest, i, j + 1, acc)
  end

  def parse_map(<<char, rest::binary>>, i, j, acc) do
    acc = Map.put(acc, {i, j}, char)
    parse_map(rest, i, j + 1, acc)
  end

  @doc """
  Solves part 1 by counting the number of 9's reached from each starting point
  and summing them.
  """
  def solve_part_1(map) do
    Enum.map(map.zero_locs, fn loc -> find_nines(map, loc, nil) end)
    |> Enum.map(&MapSet.size/1)
    |> Enum.sum()
  end

  @doc """
  Returns a `MapSet` of the unique locations of 9's visited given a single
  starting point.
  """
  def find_nines(map, {i, j}, direction) do
    current_num = Map.get(map, {i, j})

    case current_num do
      ?9 ->
        MapSet.new([{i, j}])

      _ ->
        next_points = get_next_points({i, j}, direction)

        Enum.reduce(next_points, MapSet.new(), fn {next_direction, next_point}, acc ->
          next_num = Map.get(map, next_point)

          case next_num == current_num + 1 do
            true -> MapSet.union(find_nines(map, next_point, next_direction), acc)
            false -> acc
          end
        end)
    end
  end

  @doc """
  Solves part 2 by counting the number of paths that lead to a 9 for each
  starting point and summing them.
  """
  def solve_part_2(map) do
    Enum.map(map.zero_locs, fn zero_loc -> calc_rating(map, zero_loc, nil) end)
    |> Enum.sum()
  end

  @doc """
  Counts the number of 9's for all traversals from the given starting point.
  """
  def calc_rating(map, {i, j}, direction) do
    current_num = Map.get(map, {i, j})

    case current_num do
      ?9 ->
        1

      _ ->
        next_points = get_next_points({i, j}, direction)

        Enum.reduce(next_points, 0, fn {next_direction, next_point}, acc ->
          next_num = Map.get(map, next_point)

          case next_num == current_num + 1 do
            true -> calc_rating(map, next_point, next_direction) + acc
            false -> acc
          end
        end)
    end
  end

  @doc """
  Utility: calculates next points to traverse, excluding the backwards one.
  """
  def get_next_points({i, j}, direction) do
    opposite_direction =
      case direction do
        :up -> :down
        :down -> :up
        :left -> :right
        :right -> :left
        nil -> nil
      end

    %{up: {i - 1, j}, right: {i, j + 1}, down: {i + 1, j}, left: {i, j - 1}}
    |> Map.delete(opposite_direction)
  end
end
