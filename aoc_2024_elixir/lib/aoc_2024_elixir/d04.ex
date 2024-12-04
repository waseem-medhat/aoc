defmodule Aoc2024Elixir.D04 do
  def run() do
    test1_lines = parse_lines("lib/aoc_2024_elixir/d04/test1.txt")
    input_lines = parse_lines("lib/aoc_2024_elixir/d04/input.txt")

    IO.puts("PART 1")
    test1_lines |> solve_part_1() |> IO.inspect(label: "test1")
    input_lines |> solve_part_1() |> IO.inspect(label: "input")

    IO.puts("\nPART 2")
    # input_parsed |> calculate_part_2() |> IO.inspect(label: "input")

    :ok
  end

  def parse_lines(path) do
    File.read!(path) |> String.split("\n", trim: true)
  end

  def solve_part_1(lines) do
    chunks = lines |> Stream.chunk_every(4, 1, :discard)

    n_horizontal = lines |> Stream.map(&find_horizontal/1) |> Enum.sum()
    n_vertical = chunks |> Stream.map(&find_vertical/1) |> Enum.sum()
    n_diag_forward = chunks |> Stream.map(&find_diag_forward/1) |> Enum.sum()
    n_diag_backward = chunks |> Stream.map(&find_diag_backward/1) |> Enum.sum()

    n_horizontal + n_vertical + n_diag_forward + n_diag_backward
  end

  def find_horizontal(line) do
    n_hits = Regex.scan(~r/XMAS/, line) |> length()
    n_rev_hits = Regex.scan(~r/SAMX/, line) |> length()

    n_hits + n_rev_hits
  end

  def extract_vertical_word(lines, index) when length(lines) == 4 do
    lines |> Enum.map(fn line -> String.slice(line, index, 1) end)
  end

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

  def find_diag_forward(lines) when length(lines) == 4 do
    lines
    |> Enum.with_index(fn line, i ->
      String.slice(line, i, String.length(line) - 3)
    end)
    |> find_vertical()
  end

  def find_diag_backward(lines) when length(lines) == 4 do
    lines
    |> Enum.with_index(fn line, i ->
      String.slice(line, 3 - i, String.length(line) - i)
    end)
    |> find_vertical()
  end
end
