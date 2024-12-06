defmodule Aoc2024Elixir.D06 do
  def run() do
    IO.puts("PART 1")
    parse("lib/aoc_2024_elixir/d06/test1.txt") |> solve_part_1() |> IO.inspect(label: "test1")
    parse("lib/aoc_2024_elixir/d06/input.txt") |> solve_part_1() |> IO.inspect(label: "input")

    :ok
  end

  @doc """
  Parses the file by applying `parse_line/2` on each line and merging the
  results.

  Returns a two-tuple of
  - Parsed map (as a map of coordinates => character)
  - Start position (location of the "^" as a two-tuple of coordinates)
  """
  def parse(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce({%{}, nil}, fn {line, line_idx}, {map, start_pos} ->
      {parsed_line_map, parsed_start_pos} = parse_line(line, line_idx)
      map = Map.merge(map, parsed_line_map)

      start_pos =
        case parsed_start_pos do
          nil -> start_pos
          _ -> parsed_start_pos
        end

      {map, start_pos}
    end)
  end

  @doc """
  Parses a single line. Returns a two-tuple of
  - Parsed map for that line (as a map of coordinates => character)
  - Start position (location of the "^" as a two-tuple of coordinates) if found
  and `nil` otherwise
  """
  def parse_line(line, line_idx) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce({%{}, nil}, fn {char, char_idx}, {line_map, start_pos} ->
      line_map = Map.put(line_map, {line_idx, char_idx}, char)

      start_pos =
        case char do
          "^" -> {line_idx, char_idx}
          _ -> start_pos
        end

      {line_map, start_pos}
    end)
  end

  @doc """
  Solves part 1 by starting the walk recursion from the start position going
  up.
  """
  def solve_part_1({map, start_pos}) do
    walk(start_pos, map, :up, %{})
  end

  @doc """
  Utility to move coords in a certain direction.
  """
  def shift({i, j}, :up), do: {i - 1, j}
  def shift({i, j}, :down), do: {i + 1, j}
  def shift({i, j}, :left), do: {i, j - 1}
  def shift({i, j}, :right), do: {i, j + 1}

  @doc """
  Utility to switch directions.
  """
  def turn(:up), do: :right
  def turn(:right), do: :down
  def turn(:down), do: :left
  def turn(:left), do: :up

  @doc """
  Utility to get the character in the next position.
  """
  def look_ahead(coords, map, dir) do
    target_coords = shift(coords, dir)
    Map.get(map, target_coords)
  end

  @doc """
  Recursively walks the map in the specified direction, recording all visited
  coordinates until leaving the map.
  """
  def walk(coords, map, dir, visited_coords) do
    visited_coords = Map.put(visited_coords, coords, true)

    case look_ahead(coords, map, dir) do
      "." ->
        coords = shift(coords, dir)
        walk(coords, map, dir, visited_coords)

      "^" ->
        coords = shift(coords, dir)
        walk(coords, map, dir, visited_coords)

      "#" ->
        dir = turn(dir)
        walk(coords, map, dir, visited_coords)

      nil ->
        visited_coords |> Map.keys() |> length()
    end
  end
end
