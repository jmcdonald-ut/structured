defmodule Structured.List do
  @moduledoc """
  Provides a collection of functions for working on a list.
  """

  @doc """
  Returns a sorted list.

  NOTE: Choosing an appropriate pivot can have a big impact on the performance
  on quicksort. Ultimately I chose to take the path of least resistance by
  using the head of the list as the pivot.

  ## Examples

      iex> Structured.List.quicksort([])
      []

      iex> Structured.List.quicksort([3, 1, 2])
      [1, 2, 3]

      iex> Structured.List.quicksort([9, -9, 9, -9, 9, -9, 9, 9, 9])
      [-9, -9, -9, 9, 9, 9, 9, 9, 9]
  """
  def quicksort([]), do: []
  def quicksort([head | []]), do: [head]
  def quicksort([pivot | tail]) do
    {lesser, equivalent, greater} = partition(pivot, tail)

    quicksort(lesser) ++ [pivot | equivalent] ++ quicksort(greater)
  end

  defp partition(pivot, list) do
    map = Enum.group_by(list, fn (el) ->
      cond do
        el < pivot -> :lt
        el > pivot -> :gt
        true -> :eq
      end
    end)

    {Map.get(map, :lt, []), Map.get(map, :eq, []), Map.get(map, :gt, [])}
  end

  @doc """
  Returns the given list in a sorted order.

  ## Examples

      iex> Structured.List.mergesort([])
      []

      iex> Structured.List.mergesort([3, 1, 2])
      [1, 2, 3]

      iex> Structured.List.mergesort([9, -9, -9, 9, 9, -9])
      [-9, -9, -9, 9, 9, 9]
  """
  def mergesort([]), do: []
  def mergesort([head | []]), do: [head]
  def mergesort(list) when is_list(list) do
    list_count = Enum.count(list)
    {first, second} = Enum.split(list, round(list_count / 2))

    merge(Enum.reverse(mergesort(first)), Enum.reverse(mergesort(second)))
  end

  # Merges two lists into the accumulator, greatest value into acc first.
  defp merge(l1, l2, acc \\ [])
  defp merge([], [], acc), do: acc
  defp merge([h1 | t1], [], acc), do: merge(t1, [], [h1 | acc])
  defp merge([], [h2 | t2], acc), do: merge([], t2, [h2 | acc])
  defp merge(l1, l2, acc) do
    [h1 | t1] = l1
    [h2 | t2] = l2

    cond do
      h1 == h2 -> merge(t1, t2, [h1, h2] ++ acc)
      h1 > h2 -> merge(t1, l2, [h1 | acc])
      h1 < h2 -> merge(l1, t2, [h2 | acc])
    end
  end
end
