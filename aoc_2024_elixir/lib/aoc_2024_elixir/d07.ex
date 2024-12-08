defmodule Aoc2024Elixir.D07 do
  def run() do
    IO.puts("PART1")
    parse("lib/aoc_2024_elixir/d07/test1.txt") |> solve_part_1() |> IO.inspect(label: "test1")
    parse("lib/aoc_2024_elixir/d07/input.txt") |> solve_part_1() |> IO.inspect(label: "input")

    IO.puts("\nPART2")
    parse("lib/aoc_2024_elixir/d07/test1.txt") |> solve_part_2() |> IO.inspect(label: "test1")
    parse("lib/aoc_2024_elixir/d07/input.txt") |> solve_part_2() |> IO.inspect(label: "input")

    :ok
  end

  def parse(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_equation/1)
  end

  def parse_equation(line) do
    [expected_result, operands] = line |> String.split(":", trim: true)
    expected_result = String.to_integer(expected_result)

    operands =
      operands
      |> String.trim()
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)

    {expected_result, operands}
  end

  def solve_part_1(equations) do
    equations
    |> Enum.reduce(0, fn {expected_result, operands}, acc ->
      if valid_equation?(operands, expected_result, false),
        do: expected_result + acc,
        else: acc
    end)
  end

  def solve_part_2(equations) do
    equations
    |> Enum.reduce(0, fn {expected_result, operands}, acc ->
      if valid_equation?(operands, expected_result, true),
        do: expected_result + acc,
        else: acc
    end)
  end

  def valid_equation?(operands, expected_result, include_concat) do
    permutations = operands |> length() |> gen_permutations(include_concat)

    Enum.reduce_while(permutations, false, fn perm, _acc ->
      result = execute_permutation(perm, operands, expected_result)
      if result == expected_result, do: {:halt, true}, else: {:cont, false}
    end)
  end

  @doc """
  Note that `n` is the number of OPERANDS, so each permutation will have n-1
  operations.
  """
  def gen_permutations(1, false), do: []
  def gen_permutations(2, false), do: [[:mult], [:add]]

  def gen_permutations(n, false) do
    gen_permutations(n - 1, false)
    |> Enum.flat_map(fn perm -> [[:mult | perm], [:add | perm]] end)
  end

  def gen_permutations(1, true), do: []
  def gen_permutations(2, true), do: [[:mult], [:add], [:concat]]

  def gen_permutations(n, true) do
    gen_permutations(n - 1, true)
    |> Enum.flat_map(fn perm -> [[:mult | perm], [:add | perm], [:concat | perm]] end)
  end

  @doc """
  Executes a single permutation of operations on the results.

  Returns the execution result as a number, or `:too_large`.
  """
  def execute_permutation(perm, operands, expected_result) do
    [initial | operands] = operands

    Enum.zip(operands, perm)
    |> Enum.reduce_while(initial, fn {operand, operation}, acc ->
      acc =
        case operation do
          :add -> acc + operand
          :mult -> acc * operand
          :concat -> concat(acc, operand)
        end

      if acc > expected_result, do: {:halt, :too_large}, else: {:cont, acc}
    end)
  end

  def concat(n1, n2), do: String.to_integer("#{n1}#{n2}")
end
