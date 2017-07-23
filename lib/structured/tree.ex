defmodule Structured.Tree do
  @moduledoc """
  Provides a collection of functions for working with trees represented by the
  `Structured.Tree` struct. A tree has a value, a list of children trees, and a
  map of meta values.

      iex> tree = %Structured.Tree{value: 'Dijkstra'}
      %Structured.Tree{value: 'Dijkstra'}
      iex> tree.meta
      %{}
      iex> tree.value
      'Dijkstra'
      iex> tree.children
      []

  It is important to note that the direction of trees is only tracked from a
  parent to a child. This means that given a tree, one can deduce its children,
  but one cannot deduce its parent.
  """

  defstruct children: [], value: nil, meta: %{}

  defimpl Enumerable, for: Structured.Tree do
    alias Structured.Tree, as: Tree

    def member?(tree, el), do: Tree.member?(tree, el)
    def count(tree), do: Tree.count(tree)
    def reduce(tree, acc, fun), do: Tree.reduce(tree, acc, fun)
  end

  @doc """
  Returns a tree which is constructed from a either a single value or a list.
  When a single value is given a tree is returned with no children.

  When a list is given the first value is used as the tree's value and all
  subsequent values are considered to be children. If a subsequent value is a
  list then this function is recursively called to construct that child.

  ## Examples

      iex> Structured.Tree.new(1)
      %Structured.Tree{value: 1, children: []}

      iex> Structured.Tree.new([1, 2])
      %Structured.Tree{value: 1, children: [%Structured.Tree{value: 2}]}

      iex> Structured.Tree.new([1, [2]])
      %Structured.Tree{value: 1, children: [%Structured.Tree{value: 2}]}

      iex> Structured.Tree.new([1, [2, 3]])
      %Structured.Tree{value: 1, children: [
        %Structured.Tree{value: 2, children: [%Structured.Tree{value: 3}]}
      ]}

      iex> Structured.Tree.new([1, [2, 3, [4, 5], 6], 7])
      %Structured.Tree{value: 1, children: [
        %Structured.Tree{value: 2, children: [
          %Structured.Tree{value: 3},
          %Structured.Tree{value: 4, children: [%Structured.Tree{value: 5}]},
          %Structured.Tree{value: 6}
        ]},
        %Structured.Tree{value: 7}
      ]}
  """
  def new(any) when not is_list(any), do: %Structured.Tree{value: any}
  def new([]), do: %Structured.Tree{}
  def new([head | tail]) do
    %Structured.Tree{value: head, children: Enum.map(tail, &new/1)}
  end

  @doc """
  Returns a value indicating whether this tree has a value, or any children.

  ## Examples

      iex> Structured.Tree.empty?(%Structured.Tree{value: 5, children: []})
      false

      iex> Structured.Tree.empty?(%Structured.Tree{value: nil, children: []})
      true

      iex> alias Structured.Tree, as: Tree
      iex> tree = %Tree{value: nil, children: [%Tree{value: 2, children: []}]}
      iex> Tree.empty?(tree)
      false
  """
  def empty?(%Structured.Tree{value: nil, children: []}), do: true
  def empty?(%Structured.Tree{}), do: false

  @doc """
  Returns a value indicating whether the given tree is a leaf node. A tree is
  considered a leaf node if it has no children.

  ## Examples

      iex> Structured.Tree.leaf?(%Structured.Tree{value: 5, children: []})
      true

      iex> alias Structured.Tree, as: Tree
      iex> Tree.leaf?(%Tree{value: 5, children: [%Tree{value: 3}]})
      false
  """
  def leaf?(%Structured.Tree{children: []}), do: true
  def leaf?(%Structured.Tree{children: [_head | _tail]}), do: false

  @doc """
  Returns a value indicating whether the element exists in the tree.

  ## Examples

      iex> alias Structured.Tree, as: Tree
      iex> tree = %Tree{value: 3, children: [%Tree{value: 4}]}
      iex> Tree.member?(tree, 4)
      true

      iex> alias Structured.Tree, as: Tree
      iex> tree = %Tree{value: 3, children: [%Tree{value: 5}]}
      iex> Tree.member?(tree, 6)
      false
  """
  def member?(%Structured.Tree{value: val}, el) when val === el, do: true
  def member?(%Structured.Tree{children: []}, _), do: false
  def member?(%Structured.Tree{children: children}, el) do
    Enum.any?(children, &(member?(&1, el)))
  end

  @doc """
  Returns the count of elements present in the tree.

  ## Examples

      iex> Structured.Tree.count(%Structured.Tree{})
      0

      iex> Structured.Tree.count(Structured.Tree.new([1, 2, 3, 4, [5, 6, 7]]))
      7
  """
  def count(%Structured.Tree{} = tree) do
    tree
    |> values
    |> List.flatten
    |> Enum.count
  end

  @doc """
  Reduces the tree by passing the result of `Structured.values(collection)`
  to `Enum.reduce`.
  """
  def reduce(%Structured.Tree{} = tree, acc, callback) do
    Enum.reduce(values(tree), acc, callback)
  end

  @doc """
  Returns a new tree with child appended to the list of children. When the child
  given is not already a Structured.Tree, it is wrapped in a Structured.Tree.
  Otherwise it is used directly.

  ## Examples

      iex> Structured.Tree.insert_child(%Structured.Tree{}, 5)
      %Structured.Tree{value: nil, children: [
        %Structured.Tree{value: 5, children: []}
      ]}

      iex> alias Structured.Tree, as: Tree
      iex> child = %Tree{value: 5}
      iex> parent = %Tree{value: 26}
      iex> Tree.insert_child(parent, child)
      %Structured.Tree{value: 26, children: [
        %Structured.Tree{value: 5, children: []}
      ]}
  """
  def insert_child(%Structured.Tree{} = tree, %Structured.Tree{} = child) do
    %{tree | children: tree.children ++ [child]}
  end
  def insert_child(%Structured.Tree{} = tree, child) do
    insert_child(tree, %Structured.Tree{value: child})
  end

  @doc """
  Returns a tree with the child removed. If the child given is the struct
  Structured.Tree then the first exactly matching child is removed. Otherwise
  the first child node with the same value as the child is removed.

  ## Examples

      iex> alias Structured.Tree, as: Tree
      iex> child = %Tree{value: 'Employee', meta: %{key: 'emp'}}
      iex> parent = %Tree{value: 'Manager', children: [child]}
      iex> Tree.remove_child(parent, child)
      %Structured.Tree{value: 'Manager', children: []}

      iex> alias Structured.Tree, as: Tree
      iex> child_value = 'Employee'
      iex> child = %Tree{value: child_value, meta: %{key: 'emp'}}
      iex> parent = %Tree{value: 'Manager', children: [child]}
      iex> Tree.remove_child(parent, child_value)
      %Structured.Tree{value: 'Manager', children: []}

      iex> alias Structured.Tree, as: Tree
      iex> child = %Tree{value: 'Employee', meta: %{key: 'emp'}}
      iex> other = %Tree{value: 'Employee'}
      iex> parent = %Tree{value: 'Manager', children: [child]}
      iex> Tree.remove_child(parent, other)
      %Structured.Tree{value: 'Manager', children: [
        %Structured.Tree{value: 'Employee', meta: %{key: 'emp'}}
      ]}
  """
  def remove_child(%Structured.Tree{} = tree, %Structured.Tree{} = child) do
    %{tree | children: tree.children -- [child]}
  end
  def remove_child(%Structured.Tree{} = tree, child) do
    case find_child_index(tree, child) do
      x when x >= 0 -> remove_child(tree, Enum.at(tree.children, x))
      _ -> tree
    end
  end

  @doc """
  Returns a list of all descendant trees which are considered leaves.

  ## Examples

      iex> Structured.Tree.leaves(%Structured.Tree{value: 'Employee'})
      [%Structured.Tree{value: 'Employee'}]

      iex> alias Structured.Tree, as: Tree
      iex> child = %Tree{value: 'John Stockton'}
      iex> parent = %Tree{value: 'Michael Jordan', children: [child]}
      iex> Tree.leaves(parent)
      [%Structured.Tree{value: 'John Stockton'}]

      iex> alias Structured.Tree, as: Tree
      iex> deep_tree = %Tree{
      ...>   value: 'White Fir',
      ...>   children: [
      ...>     %Tree{
      ...>       value: 'Aspen',
      ...>       children: [
      ...>         %Tree{
      ...>           value: 'Chokecherry',
      ...>           children: [%Tree{value: 'Oak Gambel'}]
      ...>         },
      ...>         %Tree{
      ...>           value: 'Engelmann Spruce',
      ...>           children: [%Tree{value: 'Douglas Fir'}]
      ...>         }
      ...>       ]
      ...>     },
      ...>     %Tree{
      ...>       value: 'Blue Spurce',
      ...>       children: [%Tree{value: 'Bristlecone Pine'}]
      ...>     },
      ...>     %Tree{value: 'Boxelder'}
      ...>   ]
      ...> }
      iex> Tree.leaves(deep_tree)
      [
        %Structured.Tree{value: 'Oak Gambel'},
        %Structured.Tree{value: 'Douglas Fir'},
        %Structured.Tree{value: 'Bristlecone Pine'},
        %Structured.Tree{value: 'Boxelder'},
      ]
  """
  def leaves(%Structured.Tree{children: []} = tree), do: [tree]
  def leaves(%Structured.Tree{children: children}) do
    Enum.flat_map(children, &leaves/1)
  end

  @doc """
  Returns the leaves of the tree as a collection of values.

  ## Examples

      iex> alias Structured.Tree, as: Tree
      iex> tree = %Tree{
      ...>   value: 'Damage',
      ...>   children: [
      ...>     %Tree{value: 'Zeratul'},
      ...>     %Tree{value: 'Lunara'},
      ...>   ]
      ...> }
      iex> Tree.leaf_values(tree)
      ['Zeratul', 'Lunara']
  """
  def leaf_values(%Structured.Tree{} = tree) do
    Enum.map(leaves(tree), &(&1.value))
  end

  @doc """
  Returns the tree as a list. The first element is considered to be the root,
  and subsequent elements are its children. If a child is a list, then its first
  element is its root value, and its subsequent are its children, and so on.

  ## Examples

      iex> alias Structured.Tree, as: Tree
      iex> tree = %Tree{
      ...>   value: 'Heroes of the Storm',
      ...>   children: [
      ...>     %Tree{
      ...>       value: 'Damage',
      ...>       children: [%Tree{value: 'Zeratul'}, %Tree{value: 'Lunara'}]
      ...>     },
      ...>     %Tree{value: 'Support', children: [%Tree{value: 'Rehgar'}]},
      ...>     %Tree{value: 'Specialist'}
      ...>   ]
      ...> }
      iex> Tree.values(tree)
      ['Heroes of the Storm',
       ['Damage', 'Zeratul', 'Lunara'],
       ['Support', 'Rehgar'],
       'Specialist'
      ]
  """
  def values(%Structured.Tree{value: nil, children: []}), do: []
  def values(%Structured.Tree{value: value, children: []}), do: [value]
  def values(%Structured.Tree{} = tree), do: internal_values(tree)

  defp find_child_index(%Structured.Tree{children: children}, child_value) do
    fun = fn(%Structured.Tree{value: value}) -> value == child_value end
    Enum.find_index(children, fun)
  end

  defp internal_values(%Structured.Tree{value: value, children: []}), do: value
  defp internal_values(%Structured.Tree{value: nil, children: children}) do
    Enum.map(children, &internal_values/1)
  end
  defp internal_values(%Structured.Tree{value: value, children: children}) do
    [value] ++ Enum.map(children, &internal_values/1)
  end
end
