defmodule D05.Solver do
  def run() do
    IO.puts("PART 1")
    parse("lib/d05/test1.txt") |> solve_part_1() |> IO.inspect(label: "test1")
    parse("lib/d05/input.txt") |> solve_part_1() |> IO.inspect(label: "input")

    IO.puts("\nPART 2")
    parse("lib/d05/test1.txt") |> solve_part_2() |> IO.inspect(label: "test1")
    parse("lib/d05/input.txt") |> solve_part_2() |> IO.inspect(label: "input")

    :ok
  end

  @doc """
  Parses the rules and updates from the given file path.
  """
  def parse(path) do
    lines = File.read!(path) |> String.split("\n", trim: true)

    rules =
      lines
      |> Enum.take_while(fn line -> String.contains?(line, "|") end)
      |> Enum.map(&parse_rule/1)

    updates =
      lines
      |> Enum.drop_while(fn line -> not String.contains?(line, ",") end)
      |> Enum.map(&parse_update/1)

    {rules, updates}
  end

  @doc """
  Parses the rule from the given line (as a two-tuple).
  """
  def parse_rule(line) do
    {n1, "|" <> rem} = Integer.parse(line)
    {n2, ""} = Integer.parse(rem)
    {n1, n2}
  end

  @doc """
  Parses the update from the given line (as a list).
  """
  def parse_update(line) do
    line |> String.split(",") |> Enum.map(&String.to_integer/1)
  end

  @doc """
  Solves part 1: filters valid updates and sums their middle numbers.

  Fetching the middle number assumes that all updates have odd lengths.
  """
  def solve_part_1({rules, updates}) do
    updates
    |> Enum.filter(fn update -> valid?(update, rules) end)
    |> Enum.map(fn update ->
      index = div(length(update), 2)
      Enum.at(update, index)
    end)
    |> Enum.sum()
  end

  @doc """
  Solves part2: filters invalid updates, reorders them, then sums their middle
  numbers.

  Fetching the middle number assumes that all updates have odd lengths.
  """
  def solve_part_2({rules, updates}) do
    updates
    |> Enum.filter(fn update -> not valid?(update, rules) end)
    |> Enum.map(fn update -> reorder(update, rules) end)
    |> Enum.map(fn update ->
      index = div(length(update), 2)
      Enum.at(update, index)
    end)
    |> Enum.sum()
  end

  @doc """
  Given an update and the rule set, determines if the update follows the correct order.
  """
  def valid?(update, rules) do
    rules = Enum.filter(rules, fn {n1, n2} -> n1 in update and n2 in update end)

    update
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn pair -> List.to_tuple(pair) in rules end)
    |> Enum.all?()
  end

  @doc """
  Given an update and the rule set, sorts the update into the correct order.

  The sorter works by calculating a score through counting the times that
  number appears in the two-tuple rules as the first element. The higher the
  score, the earlier that number should be in the sorted list.
  """
  def reorder(update, rules) do
    rules = Enum.filter(rules, fn {n1, n2} -> n1 in update and n2 in update end)

    Enum.sort_by(update, fn num ->
      Enum.count(rules, fn {first, _} -> first == num end)
    end)
  end
end

