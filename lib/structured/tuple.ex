defmodule Structured.Tuple do
  @moduledoc """
  Collection of functions for working with tuples.
  """

  @doc """
  Returns the index of the element in the ordered tuple. When the element cannot
  be found -1 is returned.

  ## Examples

      iex> Structured.Tuple.binary_search({}, 1)
      -1

      iex> Structured.Tuple.binary_search({1}, 1)
      0

      iex> Structured.Tuple.binary_search({1, 2, 3, 4, 5, 6}, 3)
      2

      iex> Structured.Tuple.binary_search({1, 2, 3, 4, 5, 6, 7}, 7)
      6
  """
  def binary_search({}, _el), do: -1
  def binary_search(tuple, el) when is_tuple(tuple) do
    bsearch(tuple, el, floor(size(tuple) / 2))
  end

  defp bsearch(tuple, el, index) do
    value = elem(tuple, index)

    cond do
      el == value -> index
      index == 0 -> -1
      index == size(tuple) - 1 -> -1
      value > el -> bsearch(tuple, el, next_index(tuple, index, :smaller))
      value < el -> bsearch(tuple, el, next_index(tuple, index, :larger))
      true -> -1
    end
  end

  defp next_index(_tuple, index, :smaller), do: floor(index / 2)
  defp next_index(tuple, index, :larger), do: ceil((index + size(tuple)) / 2)

  defp floor(val), do: round(Float.floor(val))
  defp ceil(val), do: round(Float.ceil(val))
  defp size(tuple) when is_tuple(tuple), do: tuple_size(tuple)
end
