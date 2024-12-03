defmodule Aoc2024Elixir.D03 do
  def run() do
    test1_instructions = File.read!("lib/aoc_2024_elixir/d03/test1.txt")
    test2_instructions = File.read!("lib/aoc_2024_elixir/d03/test2.txt")
    input_instructions = File.read!("lib/aoc_2024_elixir/d03/input.txt")

    test1_parsed = parse(test1_instructions)
    test2_parsed = parse(test2_instructions)
    input_parsed = parse(input_instructions)

    IO.puts("PART 1")
    test1_parsed |> calculate_part_1() |> IO.inspect(label: "test1")
    input_parsed |> calculate_part_1() |> IO.inspect(label: "input")

    IO.puts("\nPART 2")
    test2_parsed |> calculate_part_2() |> IO.inspect(label: "test2")
    input_parsed |> calculate_part_2() |> IO.inspect(label: "input")

    :ok
  end

  @doc """
  Checks if the given char (integer) is a digit.
  """
  defguard is_digit?(char) when char >= ?0 and char <= ?9

  @doc """
  Parses the given instructions string.

  The output is a list of any of these:
  - "do" if it finds "do()"
  - "dont" if it finds "don't()"
  - a number that is the multiplication result of a valid "mult" expression

  Note that the list is built using cons and will be in a reversed order.
  """
  def parse(instructions),
    do: parse(instructions, [], [], [])

  def parse("", _num_1, _num_2, parsed),
    do: parsed

  def parse("do()" <> rest, _num_1, _num_2, parsed),
    do: parse(rest, [], [], ["do" | parsed])

  def parse("don't()" <> rest, _num_1, _num_2, parsed),
    do: parse(rest, [], [], ["dont" | parsed])

  def parse("mul(" <> <<char::utf8, rest::binary>>, _num_1, _num_2, parsed)
      when is_digit?(char),
      do: parse(rest, [char], [], parsed)

  def parse("mul(" <> <<_char::utf8, rest::binary>>, _num_1, _num_2, parsed),
    do: parse(rest, [], [], parsed)

  def parse(<<char::utf8, rest::binary>>, [_ | _] = num_1, [] = _num_2, parsed)
      when is_digit?(char),
      do: parse(rest, [char | num_1], [], parsed)

  def parse("," <> <<char::utf8, rest::binary>>, [_ | _] = num_1, [] = _num_2, parsed)
      when is_digit?(char),
      do: parse(rest, num_1, [char], parsed)

  def parse(<<char::utf8, rest::binary>>, [_ | _] = num_1, [_ | _] = num_2, parsed)
      when is_digit?(char),
      do: parse(rest, num_1, [char | num_2], parsed)

  def parse(")" <> rest, [_ | _] = num_1, [_ | _] = num_2, parsed) do
    num_1 = num_1 |> Enum.reverse() |> to_string() |> String.to_integer()
    num_2 = num_2 |> Enum.reverse() |> to_string() |> String.to_integer()

    parse(rest, [], [], [num_1 * num_2 | parsed])
  end

  def parse(<<_::utf8, rest::binary>>, _num_1, _num_2, parsed),
    do: parse(rest, [], [], parsed)

  @doc """
  Given the parsed list, calculates the result based on part 1, which is simply
  the sum of all numbers (multiplication results).
  """
  def calculate_part_1(parsed), do: parsed |> Enum.filter(&is_number/1) |> Enum.sum()

  @doc """
  Given the parsed list, calculates the result based on part 2, in which the
  occurrence of a "dont" ignores all subsequent numbers.
  """
  def calculate_part_2(parsed), do: parsed |> Enum.reverse() |> calculate_part_2(0, :do)

  def calculate_part_2([], acc, _), do: acc
  def calculate_part_2(["dont" | tail], acc, _), do: calculate_part_2(tail, acc, :dont)
  def calculate_part_2(["do" | tail], acc, _), do: calculate_part_2(tail, acc, :do)
  def calculate_part_2([_ | tail], acc, :dont), do: calculate_part_2(tail, acc, :dont)
  def calculate_part_2([num | tail], acc, :do), do: calculate_part_2(tail, acc + num, :do)
end
