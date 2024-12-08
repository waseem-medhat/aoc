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

  @doc """
  Parses the entire file with the given path.
  """
  def parse(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_equation/1)
  end

  @doc """
  Parses the equation in the given line.
  """
  def parse_equation(line) do
    [calibration_val, operands] = line |> String.split(":", trim: true)
    calibration_val = String.to_integer(calibration_val)
    operands = operands |> String.trim() |> String.split(" ") |> Enum.map(&String.to_integer/1)

    {calibration_val, operands}
  end

  @doc """
  Solves part 1 by adding the calibration values of valid equation.
  """
  def solve_part_1(equations) do
    equations
    |> Enum.reduce(0, fn {calibration_val, operands}, acc ->
      if valid_equation?(operands, calibration_val, false),
        do: calibration_val + acc,
        else: acc
    end)
  end

  @doc """
  Solves part 2 by adding the calibration values of valid equation, including
  concatenation operations.
  """
  def solve_part_2(equations) do
    equations
    |> Enum.reduce(0, fn {calibration_val, operands}, acc ->
      if valid_equation?(operands, calibration_val, true),
        do: calibration_val + acc,
        else: acc
    end)
  end

  @doc """
  Checks if an equation is valid by executing all permutations of operation
  sequences until one of them matches.

  It initializes values needed for `valid_equation?/4`.
  """
  def valid_equation?([head | tail], calibration_val, include_concat?),
    do: valid_equation?(tail, calibration_val, include_concat?, head)

  @doc """
  Recursively accumulates the results of operations.

  Returns `false` if at any point the result exceeded the calibration value.
  """
  def valid_equation?(operands, calibration_val, include_concat?, acc)

  # no operands remain: compare result to calibration val
  def valid_equation?([], calibration_val, _, acc), do: acc == calibration_val

  # `acc` exceeded the calibration val: return false
  def valid_equation?(_, calibration_val, _, acc)
      when acc > calibration_val,
      do: false

  def valid_equation?([head | tail], calibration_val, false, acc) do
    valid_for_add? = valid_equation?(tail, calibration_val, false, head + acc)
    valid_for_mult? = valid_equation?(tail, calibration_val, false, head * acc)

    valid_for_add? or valid_for_mult?
  end

  def valid_equation?([head | tail], calibration_val, true, acc) do
    valid_for_add? = valid_equation?(tail, calibration_val, true, acc + head)
    valid_for_mult? = valid_equation?(tail, calibration_val, true, acc * head)
    valid_for_concat? = valid_equation?(tail, calibration_val, true, concat(acc, head))

    valid_for_add? or valid_for_mult? or valid_for_concat?
  end

  @doc """
  Utility function to concat two numbers together.
  """
  def concat(n1, n2), do: String.to_integer("#{n1}#{n2}")
end
