defmodule Aoc2024Elixir.D05 do
  def run() do
    IO.puts("PART 1")
    parse("lib/aoc_2024_elixir/d05/test1.txt") |> solve() |> IO.inspect(label: "test1")
    parse("lib/aoc_2024_elixir/d05/input.txt") |> solve() |> IO.inspect(label: "input")

    :ok
  end

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

  def parse_rule(line) do
    {n1, "|" <> rem} = Integer.parse(line)
    {n2, ""} = Integer.parse(rem)
    {n1, n2}
  end

  def parse_update(line) do
    line |> String.split(",") |> Enum.map(&String.to_integer/1)
  end

  def solve({rules, updates}) do
    updates
    |> Enum.filter(fn update -> valid?(update, rules) end)
    |> Enum.map(fn update ->
      index = div(length(update), 2)
      Enum.at(update, index)
    end)
    |> Enum.sum()
  end

  def valid?(update, rules) do
    update_rules = Enum.filter(rules, fn {n1, n2} -> n1 in update or n2 in update end)

    update
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn pair -> List.to_tuple(pair) in update_rules end)
    |> Enum.all?()
  end
end

