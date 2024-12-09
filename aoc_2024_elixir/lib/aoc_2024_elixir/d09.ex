defmodule Aoc2024Elixir.D09 do
  def run() do
    IO.puts("PART1")
    parse("lib/aoc_2024_elixir/d09/test1.txt") |> solve_part_1() |> IO.inspect(label: "test1")
    parse("lib/aoc_2024_elixir/d09/test2.txt") |> solve_part_1() |> IO.inspect(label: "test2")
    parse("lib/aoc_2024_elixir/d09/input.txt") |> solve_part_1() |> IO.inspect(label: "input")

    IO.puts("\nPART2")

    # parse_map("lib/aoc_2024_elixir/d08/test1.txt") |> solve_part_2() |> IO.inspect(label: "test1")
    # parse_map("lib/aoc_2024_elixir/d08/input.txt") |> solve_part_2() |> IO.inspect(label: "input")

    :ok
  end

  @doc """
  Parses the (single-line) file in the given path by unpacking it into a list
  of files and spaces.
  """
  def parse(path), do: File.read!(path) |> unpack()

  def solve_part_1(line) do
    line
    |> rearrange()
    |> calc_checksum()
  end

  @doc """
  Unpacks the given line into a list of files and spaces, where a file is
  represented by its ID as an integer, and spaces are `nil`.

  This 1-arity variant initializes the 4-arity one with the needed values.
  """
  def unpack(line), do: unpack(line, [], 0, :file)

  @doc """
  Recursively unpacks a line into a list of files and spaces, keeping track of
  state:
  - `curret_file_id` as incrementing integer
  - `type` which is either `:file` or `:space`
  """
  def unpack(line, acc, current_file_id, type)

  # nothing more to unpack, reverse the list back in order 
  def unpack("\n", acc, _, _), do: Enum.reverse(acc)

  # unpacking a file, repeat its id into a list and prepend it to `acc`
  def unpack(<<char, rest::binary>>, acc, file_id, :file) do
    acc = repeat(file_id, digit_to_int(char)) ++ acc
    unpack(rest, acc, file_id + 1, :space)
  end

  # unpacking a space, repeat `nil` into a list and prepend it to `acc`
  def unpack(<<char, rest::binary>>, acc, file_id, :space) do
    acc = repeat(nil, digit_to_int(char)) ++ acc
    unpack(rest, acc, file_id, :file)
  end

  @doc """
  Rearranges the line so that spaces are at the end.

  This 1-arity variant initializes the recursive 3-arity one with the needed
  values. The output of the recursive call is a reversed list, so after
  dropping extra values (that should have been spaces), the list is reversed
  back into order.
  """
  def rearrange(line) do
    vals_to_rearrange = extract_vals_to_rearrange(line)
    n_spaces = Enum.count(line, fn val -> val == nil end)

    rearrange(line, vals_to_rearrange, [])
    |> Enum.drop(n_spaces)
    |> Enum.reverse()
  end

  @doc """
  Recursively rearranges the given line using values from `vals_to_rearrange`.

  It uses cons for accumulation, so the output will be in reverse order.
  """
  def rearrange(line, vals_to_rearrange, acc)

  # no more values to rearrange, prepend the rest of the line
  def rearrange(line, [], acc),
    do: Enum.reverse(line) ++ acc

  # found a space, add value from the value list to `acc`
  def rearrange([nil | rest], [val | rest_to_rearrange], acc),
    do: rearrange(rest, rest_to_rearrange, [val | acc])

  # found a number, add value from the original line to `acc`
  def rearrange([val | rest], vals_to_rearange, acc),
    do: rearrange(rest, vals_to_rearange, [val | acc])

  @doc """
  Calculates the checksum of a line by multiplying each value by its index and
  summing the multiplication results.
  """
  def calc_checksum(line) do
    line
    |> Enum.with_index()
    |> Enum.reduce_while(0, fn
      {nil, _}, acc -> {:halt, acc}
      {val, i}, acc -> {:cont, val * i + acc}
    end)
  end

  # utilities

  @doc """
  Utility: converts the digit ASCII value to an integer, assuming only 0-9
  characters are given.
  """
  def digit_to_int(char), do: char - ?0

  @doc """
  Utility: for a given line (list), extracts values that are going be to
  shifted to spaces when calling `rearrange/3`.

  This is done by figuring out how many spaces in the line and subtracting from
  those the spaces that are already "in place" (spaces whose initial position
  would fall in the spaces range after rearrangement.)
  """
  def extract_vals_to_rearrange(line) do
    n_spaces = line |> Enum.count(fn val -> val == nil end)
    line_rev = line |> Enum.reverse()

    n_spaces_in_place =
      line_rev
      |> Enum.slice(Range.new(0, n_spaces - 1))
      |> Enum.count(fn val -> val == nil end)

    n_to_rearrange = n_spaces - n_spaces_in_place

    vals_to_rearrange =
      line_rev
      |> Enum.filter(fn val -> val != nil end)
      |> Enum.slice(Range.new(0, n_to_rearrange - 1))

    vals_to_rearrange
  end

  @doc """
  Utility: returns a list with `val` repeated `n` times.
  """
  def repeat(_, 0), do: []
  def repeat(val, n), do: Enum.map(Range.new(1, n), fn _ -> val end)
end
