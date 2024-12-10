defmodule D04.Solver do
  def run() do
    IO.puts("PART 1")
    parse_lines("lib/d04/test1.txt") |> solve_part_1() |> IO.inspect(label: "test1")
    parse_lines("lib/d04/input.txt") |> solve_part_1() |> IO.inspect(label: "input")

    IO.puts("\nPART 2")
    parse_lines("lib/d04/test1.txt") |> solve_part_2() |> IO.inspect(label: "test1")
    parse_lines("lib/d04/input.txt") |> solve_part_2() |> IO.inspect(label: "input")

    :ok
  end

  @doc """
  Reads the file and splits lines.
  """
  def parse_lines(path) do
    File.read!(path) |> String.split("\n", trim: true)
  end

  @doc """
  Finds all occurrences of "XMAS" in horizontal, vertical, or diagonal orders
  (including reversed).
  """
  def solve_part_1(lines) do
    chunks = lines |> Stream.chunk_every(4, 1, :discard)

    n_horizontal = lines |> Stream.map(&find_horizontal/1) |> Enum.sum()
    n_vertical = chunks |> Stream.map(&find_vertical/1) |> Enum.sum()
    n_diag_forward = chunks |> Stream.map(&find_diag_forward/1) |> Enum.sum()
    n_diag_backward = chunks |> Stream.map(&find_diag_backward/1) |> Enum.sum()

    n_horizontal + n_vertical + n_diag_forward + n_diag_backward
  end

  @doc """
  Finds all occurrences of "MAS" in an X shape.
  """
  def solve_part_2(lines) do
    lines
    |> Stream.chunk_every(3, 1, :discard)
    |> Stream.map(&find_x/1)
    |> Enum.sum()
  end

  @doc """
  Given a single line, finds occurrences of XMAS or its reverse.
  """
  def find_horizontal(line) do
    n_hits = Regex.scan(~r/XMAS/, line) |> length()
    n_rev_hits = Regex.scan(~r/SAMX/, line) |> length()

    n_hits + n_rev_hits
  end

  @doc """
  Given 4 lines and an index, extract the vertical word at that index.
  """
  def extract_vertical_word(lines, index) when length(lines) == 4 do
    lines |> Enum.map(fn line -> String.slice(line, index, 1) end)
  end

  @doc """
  Given 4 lines, finds vertical occurrences of XMAS or its reverse.
  """
  def find_vertical(lines) when length(lines) == 4 do
    n_elem = lines |> Enum.at(0) |> String.length()

    Range.new(0, n_elem)
    |> Enum.reduce(0, fn i, acc ->
      case extract_vertical_word(lines, i) do
        ["X", "M", "A", "S"] -> acc + 1
        ["S", "A", "M", "X"] -> acc + 1
        _ -> acc
      end
    end)
  end

  @doc """
  Given 4 lines, finds forward-diagonal occurrences if XMAS or its reverse.

  It does so by shifting the lines so that the diagonals become vertically
  aligned, and then it applies `find_vertical/1` on the aligned lines.
  """
  def find_diag_forward(lines) when length(lines) == 4 do
    lines
    |> Enum.with_index(fn line, i ->
      String.slice(line, i, String.length(line) - 3)
    end)
    |> find_vertical()
  end

  @doc """
  Given 4 lines, finds backward-diagonal occurrences if XMAS or its reverse.

  It does so by shifting the lines so that the diagonals become vertically
  aligned, and then it applies `find_vertical/1` on the aligned lines.
  """
  def find_diag_backward(lines) when length(lines) == 4 do
    lines
    |> Enum.with_index(fn line, i ->
      String.slice(line, 3 - i, String.length(line) - i)
    end)
    |> find_vertical()
  end

  @doc """
  Given 3 lines, finds all occurrences of MAS (or its reverse) in an X shape.
  """
  def find_x(lines) when length(lines) == 3 do
    n_elem = lines |> Enum.at(0) |> String.length()

    Range.new(0, n_elem - 3)
    |> Enum.reduce(0, fn i, acc ->
      substrings =
        Enum.map(lines, fn line -> String.slice(line, i, 3) end)

      case substrings do
        [<<"M", _, "S">>, <<_, "A", _>>, <<"M", _, "S">>] -> acc + 1
        [<<"M", _, "M">>, <<_, "A", _>>, <<"S", _, "S">>] -> acc + 1
        [<<"S", _, "M">>, <<_, "A", _>>, <<"S", _, "M">>] -> acc + 1
        [<<"S", _, "S">>, <<_, "A", _>>, <<"M", _, "M">>] -> acc + 1
        _ -> acc
      end
    end)
  end
end
