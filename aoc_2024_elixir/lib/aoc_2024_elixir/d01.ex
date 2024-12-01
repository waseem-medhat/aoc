defmodule Aoc2024Elixir.D01 do
  def run() do
    IO.puts("PART1")
    solve_part_1("lib/aoc_2024_elixir/d01/test1.txt") |> IO.inspect(label: "test1")
    solve_part_1("lib/aoc_2024_elixir/d01/input.txt") |> IO.inspect(label: "input")

    IO.puts("\nPART2")
    solve_part_2("lib/aoc_2024_elixir/d01/test1.txt") |> IO.inspect(label: "test1")
    solve_part_2("lib/aoc_2024_elixir/d01/input.txt") |> IO.inspect(label: "input")
    :ok
  end

  def parse_numbers(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.reduce({[], []}, fn pair, {list_1, list_2} = _acc ->
      [n1, n2] = String.split(pair, "   ")
      {n1, ""} = Integer.parse(n1)
      {n2, ""} = Integer.parse(n2)

      {[n1 | list_1], [n2 | list_2]}
    end)
  end

  def solve_part_1(path) do
    {list_1, list_2} = parse_numbers(path)
    list_1 = Enum.sort(list_1)
    list_2 = Enum.sort(list_2)

    Enum.zip_with(list_1, list_2, fn a, b -> abs(b - a) end)
    |> Enum.sum()
  end

  def solve_part_2(path) do
    {list_1, list_2} = parse_numbers(path)

    similarity_map =
      Enum.reduce(list_1, %{}, fn num, acc ->
        case Map.has_key?(acc, num) do
          true ->
            acc

          false ->
            n_duplicates = list_2 |> Enum.filter(&(&1 == num)) |> length()
            Map.put(acc, num, num * n_duplicates)
        end
      end)

    list_1
    |> Enum.map(fn num -> Map.get(similarity_map, num) end)
    |> Enum.sum()
  end
end
