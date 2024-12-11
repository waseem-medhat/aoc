defmodule D10.Solver do
  def run do
    IO.puts("PART1")
    parse("lib/d10/test1.txt") |> solve_part_1() |> IO.inspect(label: "test1")
    parse("lib/d10/test2.txt") |> solve_part_1() |> IO.inspect(label: "test2")
    parse("lib/d10/test3.txt") |> solve_part_1() |> IO.inspect(label: "test3")
    parse("lib/d10/input.txt") |> solve_part_1() |> IO.inspect(label: "input")
  end

  def parse(path) do
    File.read!(path) |> parse_map(0, 0, %{})
  end

  def parse_map("\n", _, _, acc), do: acc
  def parse_map("\n" <> rest, i, _j, acc), do: parse_map(rest, i + 1, 0, acc)

  def parse_map("0" <> rest, i, j, acc) do
    zero_locs = Map.get(acc, :zero_locs, [])

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

  def solve_part_1(map) do
    Enum.map(map.zero_locs, fn zero_loc -> walk(map, zero_loc, nil) end)
    |> Enum.map(&MapSet.size/1)
    |> Enum.sum()
  end

  def walk(map, {i, j}, direction) do
    current_num = Map.get(map, {i, j})

    case current_num do
      ?9 ->
        MapSet.new([{i, j}])

      _ ->
        calc_next_points({i, j}, direction)
        |> Enum.reduce(
          MapSet.new(),
          fn {next_direction, next_point}, acc ->
            if Map.get(map, next_point) == current_num + 1,
              do: MapSet.union(walk(map, next_point, next_direction), acc),
              else: acc
          end
        )
    end
  end

  def calc_next_points({i, j}, direction) do
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
