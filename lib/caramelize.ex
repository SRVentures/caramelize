defmodule Caramelize do
  @moduledoc """
  An Elixir library for converting the keys of snake_case maps to camelCase
  """

  @doc """
  Camelizes a variety of data structures

  * atom -> camelizes the atom
  * string -> camelizes the string
  * nested map -> camelize the nested map keys
  * list of maps -> camelize the maps
  * map -> camelize the keys
  * DateTime -> pass it straight through for easier serialization

  ## Examples

      iex(1)> Caramelize.camelize("cool_string")
      "coolString"

      iex(2)> Caramelize.camelize(:cool_string)
      "coolString"

      iex(3)> Caramelize.camelize(%{cool_atom: "foo"})
      %{"coolAtom" => "foo"}

      iex(4)> Caramelize.camelize(%{"cool_string" => "bar"})
      %{"coolString" => "bar"}

      iex(5)> Caramelize.camelize(%{cool_atom: %{another_cool_atom: "foo"}})
      %{"coolAtom" => %{"anotherCoolAtom" => "foo"}}

      iex(6)> Caramelize.camelize(%{"cool_string" => %{
      ...>      "another_cool_string" => "bar"}
      ...>    })
      %{"coolString" => %{"anotherCoolString" => "bar"}}

      iex(7)> Caramelize.camelize([%{cool_key: "foo"}])
      [%{"coolKey" => "foo"}]

      iex(8)> Caramelize.camelize(%{list_key: [%{foo: 12, bar: 13}]})
      %{"listKey" => [%{"bar" => 13, "foo" => 12}]}

      iex(9)> Caramelize.camelize(DateTime.from_unix!(1476219081))
      %DateTime{calendar: Calendar.ISO, day: 11, hour: 20, microsecond: {0, 0},
       minute: 51, month: 10, second: 21, std_offset: 0, time_zone: "Etc/UTC",
       utc_offset: 0, year: 2016, zone_abbr: "UTC"}
  """

  # Camelize atoms in a map
  def camelize(key) when is_atom(key) do
    key |> Atom.to_string() |> camelize
  end

  # Camelize strings in a map
  def camelize(key) when is_binary(key) do
    capitalized = Macro.camelize(key)
    <<first>> <> rest = capitalized
    String.downcase(<<first>>) <> rest
  end

  # if a nested map, camelize the nested map keys
  def camelize({key, value}) when is_map(value) or is_list(value) do
    {camelize(key), camelize(value)}
  end

  # if a list of maps, camelize the maps
  def camelize(map_list) when is_list(map_list) do
    Enum.map(map_list, fn
      %{__struct__: _} = map ->
        map
        |> Map.from_struct()
        |> camelize

      map = %{} ->
        camelize(map)

      any ->
        any
    end)
  end

  # if a map, camelize the keys
  def camelize({key, value}) do
    key = camelize(key)
    {key, value}
  end

  def camelize(%struct{} = datetime) when struct in [DateTime, Ecto.DateTime, NaiveDateTime] do
    datetime
  end

  # if a struct, convert to map and then camelize
  def camelize(%{__struct__: _} = map) do
    map
    |> Map.from_struct()
    |> camelize
  end

  # base camelize function
  def camelize(%{} = map) do
    map
    |> Enum.map(&__MODULE__.camelize/1)
    |> Map.new()
  end
end
