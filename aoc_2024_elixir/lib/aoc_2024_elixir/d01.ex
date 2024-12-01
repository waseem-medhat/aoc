defmodule Aoc2024Elixir.D01 do
  def run() do
    test_numbers = parse_numbers("lib/aoc_2024_elixir/d01/test1.txt")
    input_numbers = parse_numbers("lib/aoc_2024_elixir/d01/input.txt")

    IO.puts("PART1")
    solve_part_1(test_numbers) |> IO.inspect(label: "test1")
    solve_part_1(input_numbers) |> IO.inspect(label: "input")

    IO.puts("\nPART2")
    solve_part_2(test_numbers) |> IO.inspect(label: "test1")
    solve_part_2(input_numbers) |> IO.inspect(label: "input")

    :ok
  end

  @doc """
  Parses the number lists from the given file path.
  """
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

  @doc """
  Calculates the score for part 1 by sorting the lists and calculating the
  absolute distance between each pair.
  """
  def solve_part_1({list_1, list_2}) do
    list_1 = Enum.sort(list_1)
    list_2 = Enum.sort(list_2)

    Enum.zip_with(list_1, list_2, fn a, b -> abs(b - a) end)
    |> Enum.sum()
  end

  @doc """
  Calculates the score for part 2 by building a similarity map (see
  `build_similarity_map`). This was done to memoize the results as there are
  many duplicates in list_1.
  """
  def solve_part_2({list_1, list_2}) do
    build_similarity_map(list_1, list_2)
    |> Enum.reduce(0, fn {_, %{freq: f, score: s}}, acc -> acc + f * s end)
  end

  @doc """
  Builds the similarity map with the following structure:

  - Each key is a number from list_1
  - Each value is a map with:
    + How many occurrences of that number in list 2
    + The similarity score
  """
  def build_similarity_map(list_1, list_2) do
    Enum.reduce(list_1, %{}, fn num, acc ->
      case Map.has_key?(acc, num) do
        true ->
          Map.update!(acc, num, fn %{freq: f, score: s} -> %{freq: f + 1, score: s} end)

        false ->
          n_duplicates = list_2 |> Enum.filter(&(&1 == num)) |> length()
          score = num * n_duplicates
          Map.put(acc, num, %{freq: 1, score: score})
      end
    end)
  end
end
