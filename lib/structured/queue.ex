defmodule Structured.Queue do
  @moduledoc """
  A collection of functions for operating on a list like a queue.

  A queue exhibits "first-in first-out" behavior. The list has one end from
  which data is read, and the other end which data is inserted.

  ## Notes on Asymptotic Behavior

  `peek` and `dequeue` are optimized to exhibit O(1) behavior. This is achieved
  by treating the first item in the list as the first item "in".

  `enqueue` exhibits O(N) behavior. This is because of how lists are represented
  internally in Elixir. Elixir lists are effectively linked lists where each
  item is treated as a pair containing the head (the value) and a tail which
  represents the remainder of the list. Adding an item to the end of the list
  means that the entire list must be walked.
  """

  @doc """
  Returns a pair where the first item is the next item to be dequeued, and the
  second item is the unaltered queue.

  ## Asymptotic Behavior

  This exhibits O(1) behavior since it treats the first item in the list as the
  first item in.

  ## Examples

      iex> Structured.Queue.peek([1, 2, 3, 4])
      {1, [1, 2, 3, 4]}

      iex> Structured.Queue.peek([])
      {nil, []}
  """
  def peek([]), do: {nil, []}
  def peek([head | _tail] = list), do: {head, list}

  @doc """
  Returns a pair where the first item is the dequeued item, and the second item
  is the queue without the dequeued item.

  ## Asymptotic Behavior

  This exhibits O(1) behavior since it treats the first item in the list as the
  first item in.

  ## Examples

      iex> Structured.Queue.dequeue([])
      {nil, []}

      iex> Structured.Queue.dequeue([1, 2, 3, 4])
      {1, [2, 3, 4]}
  """
  def dequeue([]), do: {nil, []}
  def dequeue([head | tail]), do: {head, tail}

  @doc """
  Returns a queue with the given value appended at the end.

  ## Asymptotic Behavior

  This exhibits O(N) behavior. Lists in Elixir are implemented as linked-lists.
  Essentially the list is a collection of pairs where the first item in the pair
  is considered the head, and the second item is considered the tail. Appending
  an item to the list requires walking the entire list.

  ## Examples

      iex> Structured.Queue.enqueue([1, 2, 3], 4)
      [1, 2, 3, 4]

      iex> Structured.Queue.enqueue([], 1)
      [1]
  """
  def enqueue([], value), do: [value]
  def enqueue([head | tail], value), do: [head | enqueue(tail, value)]
end
