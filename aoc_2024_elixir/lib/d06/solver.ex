defmodule D06.Solver do
  def run() do
    IO.puts("PART 1")
    parse("lib/d06/test1.txt") |> solve_part_1() |> IO.inspect(label: "test1")
    parse("lib/d06/input.txt") |> solve_part_1() |> IO.inspect(label: "input")

    IO.puts("\nPART 2")
    parse("lib/d06/test1.txt") |> solve_part_2() |> IO.inspect(label: "test1")
    parse("lib/d06/input.txt") |> solve_part_2() |> IO.inspect(label: "input")

    :ok
  end

  @doc """
  Parses the file by applying `parse_line/2` on each line and merging the
  results.

  Returns a two-tuple of
  - Parsed map (as a map of coordinates => character)
  - Starting coordinates (location of the "^" as a two-tuple of coordinates)
  """
  def parse(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce({%{}, nil}, fn {line, line_idx}, {map, start_coords} ->
      {parsed_line_map, parsed_start_coords} = parse_line(line, line_idx)
      map = Map.merge(map, parsed_line_map)

      start_coords =
        case parsed_start_coords do
          nil -> start_coords
          _ -> parsed_start_coords
        end

      {map, start_coords}
    end)
  end

  @doc """
  Parses a single line. Returns a two-tuple of
  - Parsed map for that line (as a map of coordinates => character)
  - Starting coordinates (location of the "^" as a two-tuple of coordinates) if
  found and `nil` otherwise
  """
  def parse_line(line, line_idx) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce({%{}, nil}, fn {char, char_idx}, {line_map, start_coords} ->
      line_map = Map.put(line_map, {line_idx, char_idx}, char)

      start_coords =
        case char do
          "^" -> {line_idx, char_idx}
          _ -> start_coords
        end

      {line_map, start_coords}
    end)
  end

  @doc """
  Solves part 1 by executing the `walk/2` recursion.
  """
  def solve_part_1({map, start_coords}) do
    {visited_coords, false} = walk(map, start_coords)

    visited_coords
    |> Map.keys()
    |> length()
  end

  @doc """
  Solves part 2 by recording visited coordinates from part 1, and for each one
  of those, replace the character at the coordinates with "#" and check if it
  causes a loop.
  """
  def solve_part_2({map, start_coords}) do
    {visited_coords, false} = walk(map, start_coords)

    Enum.filter(visited_coords, fn {coords, _} ->
      map = Map.put(map, coords, "#")
      {_, looped?} = walk(map, start_coords)
      looped?
    end)
    |> length()
  end

  @doc """
  Recursively walks the map in the specified direction, recording all visited
  coordinates until any of the following:
  - Leaving the map
  - Looping back into the starting coordinates (in the same direction)

  Returns a two-tuple of:
  - Visited coordinate/direction combinations as a map of coordinates =>
  direction set (e.g. `%{{6, 2} => MapSet.new([:up, :right])}`)
  - Boolean for whether or the walk entered a loop
  """
  def walk(map, start_coords) do
    walk(map, start_coords, :up, %{})
  end

  defp walk(map, coords, dir, visited_coords) do
    dirs_in_coord = Map.get(visited_coords, coords, MapSet.new())

    case MapSet.member?(dirs_in_coord, dir) do
      true ->
        {visited_coords, true}

      false ->
        dirs_in_coord = MapSet.put(dirs_in_coord, dir)
        visited_coords = Map.put(visited_coords, coords, dirs_in_coord)

        case look_ahead(coords, map, dir) do
          "." ->
            coords = shift(coords, dir)
            walk(map, coords, dir, visited_coords)

          "^" ->
            coords = shift(coords, dir)
            walk(map, coords, dir, visited_coords)

          "#" ->
            dir = turn(dir)
            walk(map, coords, dir, visited_coords)

          nil ->
            {visited_coords, false}
        end
    end
  end

  # helper functions

  defp shift({i, j}, :up), do: {i - 1, j}
  defp shift({i, j}, :down), do: {i + 1, j}
  defp shift({i, j}, :left), do: {i, j - 1}
  defp shift({i, j}, :right), do: {i, j + 1}

  defp turn(:up), do: :right
  defp turn(:right), do: :down
  defp turn(:down), do: :left
  defp turn(:left), do: :up

  defp look_ahead(coords, map, dir) do
    target_coords = shift(coords, dir)
    Map.get(map, target_coords)
  end
end
