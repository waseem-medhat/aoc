defmodule D02.Solver do
  def run() do
    IO.puts("PART 1")

    parse_reports("lib/d02/test1.txt") |> solve_part_1() |> IO.inspect(label: "test1")
    parse_reports("lib/d02/input.txt") |> solve_part_1() |> IO.inspect(label: "input")

    IO.puts("\nPART 2")
    parse_reports("lib/d02/test1.txt") |> solve_part_2() |> IO.inspect(label: "test1")
    parse_reports("lib/d02/input.txt") |>solve_part_2() |> IO.inspect(label: "input")

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

  defp has_safe_permutations?(report, n) when n == length(report), do: false

  defp has_safe_permutations?(report, n) do
    permutation = List.delete_at(report, n)

    case safe?(permutation) do
      true -> true
      false -> has_safe_permutations?(report, n + 1)
    end
  end
end
