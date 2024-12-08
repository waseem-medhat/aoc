defmodule Aoc2024Elixir.D07 do
  def run() do
    parse("lib/aoc_2024_elixir/d07/test1.txt") |> solve_part_1() |> IO.inspect(label: "test1")
    parse("lib/aoc_2024_elixir/d07/input.txt") |> solve_part_1() |> IO.inspect(label: "input")

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
      if valid_equation?(operands, expected_result),
        do: expected_result + acc,
        else: acc
    end)
  end

  def valid_equation?(operands, expected_result) do
    permutations = operands |> length() |> gen_permutations()

    Enum.reduce_while(permutations, false, fn perm, _acc ->
      result = execute_permutation(perm, operands, expected_result)
      if result == expected_result, do: {:halt, true}, else: {:cont, false}
    end)
  end

  @doc """
  Note that `n` is the number of OPERANDS, so each permutation will have n-1
  operations.
  """
  def gen_permutations(1), do: []
  def gen_permutations(2), do: [[:mult], [:add]]

  def gen_permutations(n) do
    gen_permutations(n - 1)
    |> Enum.flat_map(fn perm -> [[:mult | perm], [:add | perm]] end)
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
        end

      if acc > expected_result, do: {:halt, :too_large}, else: {:cont, acc}
    end)
  end
end
