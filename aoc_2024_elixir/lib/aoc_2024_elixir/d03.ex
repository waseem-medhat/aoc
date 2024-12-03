defmodule Aoc2024Elixir.D03 do
  def run() do
    test_instructions = File.read!("lib/aoc_2024_elixir/d03/test1.txt")
    input_instructions = File.read!("lib/aoc_2024_elixir/d03/input.txt")

    IO.puts("PART 1")
    solve(test_instructions) |> IO.inspect(label: "test1")
    solve(input_instructions) |> IO.inspect(label: "input")

    # IO.puts("\nPART 2")
    # solve_part_2(test_reports) |> IO.inspect(label: "test1")
    # solve_part_2(input_reports) |> IO.inspect(label: "input")

    :ok
  end

  @doc """
  Checks if the given char (integer) is a digit.
  """
  defguard is_digit?(char) when char >= 48 and char <= 57

  # start
  def solve(instructions),
    do: solve(instructions, [], [], 0)

  # end
  def solve("", _num_1, _num_2, acc),
    do: acc

  # valid opening with digit after it
  def solve(<<"mul(", char::utf8, rest::binary>>, _num_1, _num_2, acc)
      when is_digit?(char) do
    solve(rest, [char], [], acc)
  end

  # invalid opening cause no digit after it
  def solve(<<"mul(", _char::utf8, rest::binary>>, _num_1, _num_2, acc),
    do: solve(rest, [], [], acc)

  # we have a num 1 and found a digit
  def solve(<<char::utf8, rest::binary>>, [_ | _] = num_1, [] = _num_2, acc)
      when is_digit?(char) do
    solve(rest, [char | num_1], [], acc)
  end

  # comma
  def solve(<<",", char::utf8, rest::binary>>, [_ | _] = num_1, [] = _num_2, acc)
      when is_digit?(char),
      do: solve(rest, num_1, [char], acc)

  # we have a num 2 and found a digit
  def solve(<<char::utf8, rest::binary>>, [_ | _] = num_1, [_ | _] = num_2, acc)
      when is_digit?(char),
      do: solve(rest, num_1, [char | num_2], acc)

  # closer
  def solve(<<")", rest::binary>>, [_ | _] = num_1, [_ | _] = num_2, acc) do
    num_1 = num_1 |> Enum.reverse() |> to_string() |> String.to_integer()
    num_2 = num_2 |> Enum.reverse() |> to_string() |> String.to_integer()

    solve(rest, [], [], acc + num_1 * num_2)
  end

  # anything else is invalid
  def solve(<<_::utf8, rest::binary>>, _num_1, _num_2, acc),
    do: solve(rest, [], [], acc)
end
