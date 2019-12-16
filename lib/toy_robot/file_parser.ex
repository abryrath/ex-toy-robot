defmodule ToyRobot.FileParser do
  @type directive() :: {atom(), map()}

  @spec get_directives(file_name :: String.t()) :: list()
  def get_directives(file_name) when is_binary(file_name) do
    file_name
    |> File.read!()
    |> split_directives()
    |> parse_directives()
  end

  def get_directives(_file_name) do
    raise ArgumentError
  end

  @doc """
  Split the file contents into a list of directives.

  Remove any directives that are just empty strings
  """
  @spec split_directives(str :: String.t()) :: list()
  def split_directives(str) do
    str
    |> String.split(~r/\n/)
    |> Enum.map(fn str -> String.trim(str) end)
    |> Enum.filter(fn str -> String.length(str) > 0 end)
    |> Enum.to_list()
  end

  def parse_directives(commands) do
    commands
    # |> Enum.filter(fn directive -> is_valid_directive?(directive) end)
    |> Enum.map(fn command -> transform(command) end)
    |> Enum.filter(fn directive -> !is_nil(directive) end)
  end

  def transform(directive) do
    lc = String.downcase(directive)

    cond do
      String.starts_with?(lc, "place") -> parse_directive(lc, :place)
      String.starts_with?(lc, "move") -> parse_directive(lc, :move)
      String.starts_with?(lc, "left") -> parse_directive(lc, :left)
      String.starts_with?(lc, "right") -> parse_directive(lc, :right)
      String.starts_with?(lc, "report") -> parse_directive(lc, :report)
      true -> nil
    end
  end

  defp parse_directive(directive, :place) do
    captures =
      Regex.named_captures(~r/place (?<x>[\d|\s]+),(?<y>[\d|\s]+),(?<d>[\d|\s|\w]+)/, directive)

    x = Map.fetch!(captures, "x") |> String.trim() |> String.to_integer()
    y = Map.fetch!(captures, "y") |> String.trim() |> String.to_integer()
    dir = Map.fetch!(captures, "d") |> String.trim()
    d = cond do
      String.starts_with?(dir, "n") -> 0
      String.starts_with?(dir, "e") -> 1
      String.starts_with?(dir, "s") -> 2
      String.starts_with?(dir, "w") -> 3
      true -> String.to_integer(dir)
    end

    {:place, %{:x => x, :y => y, :dir => d}}
  end

  defp parse_directive(_directive, :move), do: {:move, %{}}
  defp parse_directive(_directive, :left), do: {:left, %{}}
  defp parse_directive(_directive, :right), do: {:right, %{}}
  defp parse_directive(_directive, :report), do: {:report, %{}}
end
