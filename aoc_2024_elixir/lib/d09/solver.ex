defmodule D09.Solver do
  def run() do
    IO.puts("PART1")
    parse("lib/d09/test1.txt") |> solve_part_1() |> IO.inspect(label: "test1")
    parse("lib/d09/test2.txt") |> solve_part_1() |> IO.inspect(label: "test2")
    parse("lib/d09/input.txt") |> solve_part_1() |> IO.inspect(label: "input")

    IO.puts("\nPART2")

    parse("lib/d09/test1.txt") |> solve_part_2() |> IO.inspect(label: "test1")
    parse("lib/d09/input.txt") |> solve_part_2() |> IO.inspect(label: "input")

    :ok
  end

  @doc """
  Parses the (single-line) file in the given path by unpacking it into a list
  of files and spaces.
  """
  def parse(path), do: File.read!(path) |> unpack()

  @doc """
  Unpacks the given line into a list of files and spaces, where a file is
  represented by its ID as an integer, and spaces are `nil`.
  """
  def unpack(line), do: unpack(line, [], 0, :file)

  @doc """
  Recursively unpacks a line into a list of files and spaces, keeping track of
  state:
  - `curret_file_id` as incrementing integer
  - `type` which is either `:file` or `:space`
  """
  def unpack(line, acc, current_file_id, type)

  def unpack("\n", acc, _, _), do: Enum.reverse(acc)

  def unpack(<<char, rest::binary>>, acc, file_id, :file) do
    acc = [%{id: file_id, size: digit_to_int(char)} | acc]
    unpack(rest, acc, file_id + 1, :space)
  end

  def unpack(<<char, rest::binary>>, acc, file_id, :space) do
    acc = [%{id: nil, size: digit_to_int(char)} | acc]
    unpack(rest, acc, file_id, :file)
  end

  def solve_part_1(block_list) do
    block_list
    |> blocks_to_vals()
    |> rearrange_vals()
    |> calc_checksum()
  end

  def solve_part_2(block_list) do
    block_list
    |> rearrange_blocks()
    |> blocks_to_vals()
    |> calc_checksum()
  end

  @doc """
  Rearranges the line so that spaces are at the end.

  This 1-arity variant initializes the recursive 3-arity one with the needed
  values. The output of the recursive call is a reversed list, so after
  dropping extra values (that should have been spaces), the list is reversed
  back into order.
  """
  def rearrange_vals(line) do
    vals_to_rearrange = extract_vals_to_rearrange(line)
    n_spaces = Enum.count(line, fn val -> val == nil end)

    rearrange_vals(line, vals_to_rearrange, [])
    |> Enum.drop(n_spaces)
    |> Enum.reverse()
  end

  @doc """
  Recursively rearranges the given line using values from `vals_to_rearrange`.

  It uses cons for accumulation, so the output will be in reverse order.
  """
  def rearrange_vals(line, vals_to_rearrange, acc)

  def rearrange_vals(line, [], acc),
    do: Enum.reverse(line) ++ acc

  def rearrange_vals([nil | rest], [val | rest_to_rearrange], acc),
    do: rearrange_vals(rest, rest_to_rearrange, [val | acc])

  def rearrange_vals([val | rest], vals_to_rearange, acc),
    do: rearrange_vals(rest, vals_to_rearange, [val | acc])

  @doc """
  Recursively rearranges blocks.
  """
  def rearrange_blocks(block_list),
    do: rearrange_blocks(block_list, [], MapSet.new([]))

  defp rearrange_blocks([], acc, _shifted),
    do: Enum.reverse(acc)

  defp rearrange_blocks([%{id: nil, size: space_size} = space_block | rest], acc, shifted) do
    to_shift =
      rest
      |> Enum.reverse()
      |> Enum.find(fn block ->
        space? = is_nil(block.id)
        already_shifted? = MapSet.member?(shifted, block)
        too_large? = block.size > space_size

        not (space? or already_shifted? or too_large?)
      end)

    case to_shift do
      nil ->
        acc = [space_block | acc]
        rearrange_blocks(rest, acc, shifted)

      file_block ->
        shifted = MapSet.put(shifted, file_block)

        case merge_blocks(space_block, file_block) do
          [block] ->
            acc = [block | acc]
            rearrange_blocks(rest, acc, shifted)

          [block, space_block] ->
            acc = [block | acc]
            rearrange_blocks([space_block | rest], acc, shifted)
        end
    end
  end

  defp rearrange_blocks([block | rest], acc, shifted) do
    acc =
      case MapSet.member?(shifted, block) do
        true -> [%{id: nil, size: block.size} | acc]
        false -> [block | acc]
      end

    rearrange_blocks(rest, acc, shifted)
  end

  @doc """
  Calculates the checksum of a line by multiplying each value by its index and
  summing the multiplication results.
  """
  def calc_checksum(vals) do
    vals
    |> Enum.with_index()
    |> Enum.reduce(0, fn
      {nil, _}, acc -> acc
      {val, i}, acc -> val * i + acc
    end)
  end

  def merge_blocks(%{id: nil, size: space_size}, %{id: file_id, size: file_size}) do
    cond do
      space_size > file_size ->
        [%{id: file_id, size: file_size}, %{id: nil, size: space_size - file_size}]

      space_size == file_size ->
        [%{id: file_id, size: file_size}]
    end
  end

  @doc """
  Utility: converts the digit ASCII value to an integer, assuming only 0-9
  characters are given.
  """
  def digit_to_int(char), do: char - ?0

  @doc """
  Utility: spreads blocks in the given list as values, repeating the IDs
  according to the sizes.
  """
  def blocks_to_vals(block_list), do: blocks_to_vals(block_list, [])

  defp blocks_to_vals([], acc), do: Enum.reverse(acc)

  defp blocks_to_vals([%{id: id, size: size} | rest], acc) do
    acc = List.duplicate(id, size) ++ acc
    blocks_to_vals(rest, acc)
  end

  @doc """
  Utility: for a given line (list), extracts values that are going be to
  shifted to spaces when calling `rearrange_vals/3`.

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
end
