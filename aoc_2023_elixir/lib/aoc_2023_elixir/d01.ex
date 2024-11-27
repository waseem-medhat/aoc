defmodule Aoc2023Elixir.D01 do
  def run() do
    solve("lib/aoc_2023_elixir/d01/test1.txt") |> IO.inspect(label: "test1")
    solve("lib/aoc_2023_elixir/d01/test2.txt") |> IO.inspect(label: "test2")
    solve("lib/aoc_2023_elixir/d01/input.txt") |> IO.inspect(label: "input")

    :ok
  end

  defp solve(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.map(&extract_digits/1)
    |> Enum.sum()
  end

  defp find_number(str) do
    digit_numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    word_numbers = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

    word_numbers
    |> Enum.zip(digit_numbers)
    |> Enum.reduce(nil, fn
      {word, digit}, nil ->
        if String.starts_with?(str, digit) or String.starts_with?(str, word),
          do: digit,
          else: nil

      {_word, _digit}, found_digit ->
        found_digit
    end)
  end

  defp extract_digits(str), do: extract_digits(str, [])

  defp extract_digits("", digits) do
    # we added digits through prepending, so the list is in reversed order
    first_digit = List.last(digits)
    last_digit = hd(digits)

    {value, ""} = Integer.parse(first_digit <> last_digit)
    value
  end

  defp extract_digits(str, digits) do
    digits =
      case find_number(str) do
        nil -> digits
        digit -> [digit | digits]
      end

    <<_::utf8, rest::binary>> = str
    extract_digits(rest, digits)
  end
end
