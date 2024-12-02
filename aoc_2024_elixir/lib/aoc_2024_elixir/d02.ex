defmodule Aoc2024Elixir.D02 do
  def run() do
    test_reports = parse_reports("lib/aoc_2024_elixir/d02/test1.txt")
    input_reports = parse_reports("lib/aoc_2024_elixir/d02/input.txt")

    IO.puts("PART 1")
    solve_part_1(test_reports) |> IO.inspect(label: "test1")
    solve_part_1(input_reports) |> IO.inspect(label: "input")

    IO.puts("\nPART 2")
    solve_part_2(test_reports) |> IO.inspect(label: "test1")
    solve_part_2(input_reports) |> IO.inspect(label: "input")
    :ok
  end

  @doc """
  Parses the file 
  """
  def parse_reports(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> line |> String.split(" ") |> Enum.map(&String.to_integer/1) end)
  end

  def solve_part_1(reports) do
    reports
    |> Enum.map(&safe?/1)
    |> Enum.filter(& &1)
    |> length()
  end

  def solve_part_2(reports) do
    reports
    |> Enum.map(&safe_with_tolerance?/1)
    |> Enum.filter(& &1)
    |> length()
  end

  @doc """
  Determines if a report is safe which means:
  - Numbers follow an increasing or decreasing order (same numbers are unsafe)
  - Numbers increase or decrease by a difference between 1 and 3 inclusive

  Note that `safe/1` simply checks the ordering before handing it off to
  `safe/2`
  """
  def safe?([a | [b | _]]) when a == b, do: false
  def safe?([a | [b | _]] = report), do: safe?(report, a < b)

  defp safe?([], _ascending?), do: true
  defp safe?([_], _ascending?), do: true
  defp safe?([a | [b | _]], _ascending?) when a == b, do: false

  defp safe?([a | [b | _]] = report, ascending?) do
    cond do
      abs(a - b) > 3 -> false
      a < b != ascending? -> false
      true -> safe?(tl(report), ascending?)
    end
  end

  @doc """
  Determines if a report is safe, or would be safe if an element was removed.

  This function only does a simple check to avoid unnecessary work on already
  safe reports before handing off to `has_safe_permutations?/1`.
  """
  def safe_with_tolerance?(report) do
    case safe?(report) do
      true -> true
      false -> has_safe_permutations?(report)
    end
  end

  @doc """
  Determines if the removal of any element would make the report safe.
  """
  def has_safe_permutations?(report), do: has_safe_permutations?(report, 0)
  def has_safe_permutations?(report, n) when n == length(report), do: false

  def has_safe_permutations?(report, n) do
    permutation = List.delete_at(report, n)

    case safe?(permutation) do
      true -> true
      false -> has_safe_permutations?(report, n + 1)
    end
  end
end
