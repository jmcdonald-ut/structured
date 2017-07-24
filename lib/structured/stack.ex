defmodule Structured.Stack do
  @moduledoc """
  Provides a set of functions for operating on a list as if it were a stack.

  A stack exhibits "last-in first-out" behavior. This means that the last item
  added to the stack is the first item to be read. Elixir's list represents
  itself well for this. `pop`, `top`, and `push` all exhibit O(1) behavior.
  """

  @doc """
  Returns the value at the top of the stack (the first item in the list). You
  can optionally supply a default value that is returned if the stack is empty.

  ## Examples

      iex> Structured.Stack.top([6, 5, 4, 3, 2, 1])
      6

      iex> Structured.Stack.top([])
      nil

      iex> Structured.Stack.top([], :empty)
      :empty
  """
  def top(list, default \\ nil)
  def top([], default), do: default
  def top([head | _tail], _default), do: head

  @doc """
  Returns a pair containing the top of the stack, and the altered stack without
  the top value.

  ## Examples

      iex> Structured.Stack.pop([6, 5, 4, 3, 2, 1])
      {6, [5, 4, 3, 2, 1]}

      iex> Structured.Stack.pop([1])
      {1, []}

      iex> Structured.Stack.pop([])
      {nil, []}

      iex> Structured.Stack.pop([], :empty)
      {:empty, []}
  """
  def pop(list, default \\ nil)
  def pop([], default), do: {default, []}
  def pop([head | tail], _default), do: {head, tail}

  @doc """
  Returns the stack with the value pushed on top.

  ## Examples

      iex> Structured.Stack.push([5, 4, 3, 2, 1], 6)
      [6, 5, 4, 3, 2, 1]

      iex> Structured.Stack.push([], 1)
      [1]
  """
  def push(stack, value) when is_list(stack), do: [value | stack]
end
