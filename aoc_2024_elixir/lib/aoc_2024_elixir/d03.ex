defmodule Aoc2024Elixir.D03 do
  def run() do
    test1_instructions = File.read!("lib/aoc_2024_elixir/d03/test1.txt")
    test2_instructions = File.read!("lib/aoc_2024_elixir/d03/test2.txt")
    input_instructions = File.read!("lib/aoc_2024_elixir/d03/input.txt")

    test1_parsed = parse(test1_instructions)
    test2_parsed = parse(test2_instructions)
    input_parsed = parse(input_instructions)

    IO.puts("PART 1")
    test1_parsed |> caluclate_part_1() |> IO.inspect(label: "test1")
    input_parsed |> caluclate_part_1() |> IO.inspect(label: "input")

    IO.puts("\nPART 2")
    test2_parsed |> caluclate_part_2() |> IO.inspect(label: "test2")
    input_parsed |> caluclate_part_2() |> IO.inspect(label: "input")

    :ok
  end

  @doc """
  Checks if the given char (integer) is a digit.
  """
  defguard is_digit?(char) when char >= 48 and char <= 57

  # start
  def parse(instructions),
    do: parse(instructions, [], [], [])

  # end
  def parse("", _num_1, _num_2, parsed),
    do: parsed

  # do's
  def parse(<<"do()", rest::binary>>, _num_1, _num_2, parsed),
    do: parse(rest, [], [], ["do" | parsed])

  # dont's
  def parse(<<"don't()", rest::binary>>, _num_1, _num_2, parsed),
    do: parse(rest, [], [], ["dont" | parsed])

  # valid opening with digit after it
  def parse(<<"mul(", char::utf8, rest::binary>>, _num_1, _num_2, parsed)
      when is_digit?(char) do
    parse(rest, [char], [], parsed)
  end

  # invalid opening cause no digit after it
  def parse(<<"mul(", _char::utf8, rest::binary>>, _num_1, _num_2, parsed),
    do: parse(rest, [], [], parsed)

  # we have a num 1 and found a digit
  def parse(<<char::utf8, rest::binary>>, [_ | _] = num_1, [] = _num_2, parsed)
      when is_digit?(char) do
    parse(rest, [char | num_1], [], parsed)
  end

  # comma
  def parse(<<",", char::utf8, rest::binary>>, [_ | _] = num_1, [] = _num_2, parsed)
      when is_digit?(char),
      do: parse(rest, num_1, [char], parsed)

  # we have a num 2 and found a digit
  def parse(<<char::utf8, rest::binary>>, [_ | _] = num_1, [_ | _] = num_2, parsed)
      when is_digit?(char),
      do: parse(rest, num_1, [char | num_2], parsed)

  # closer
  def parse(<<")", rest::binary>>, [_ | _] = num_1, [_ | _] = num_2, parsed) do
    num_1 = num_1 |> Enum.reverse() |> to_string() |> String.to_integer()
    num_2 = num_2 |> Enum.reverse() |> to_string() |> String.to_integer()

    parse(rest, [], [], [num_1 * num_2 | parsed])
  end

  # anything else is invalid
  def parse(<<_::utf8, rest::binary>>, _num_1, _num_2, parsed),
    do: parse(rest, [], [], parsed)

  def caluclate_part_1(parsed), do: parsed |> Enum.filter(&is_number/1) |> Enum.sum()

  def caluclate_part_2(parsed), do: parsed |> Enum.reverse() |> calculate_part_2(0, :do)

  def calculate_part_2([], acc, _), do: acc
  def calculate_part_2(["dont" | tail], acc, _), do: calculate_part_2(tail, acc, :dont)
  def calculate_part_2(["do" | tail], acc, _), do: calculate_part_2(tail, acc, :do)
  def calculate_part_2([_ | tail], acc, :dont), do: calculate_part_2(tail, acc, :dont)
  def calculate_part_2([num | tail], acc, :do), do: calculate_part_2(tail, acc + num, :do)
end
