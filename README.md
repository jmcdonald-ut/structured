# Structured

A collection of data structures and algorithms. My hope is that by implementing
this project I can learn more about Elixir, functional programming, and brush up
my knowledge on data structures and algorithms. If I do continue to use Elixir
I hope that I can use at least some of this project in the future.


- [x] Tuples
    - [x] Binary Search
- [x] Lists
    - [x] Quicksort
    - [x] Mergesort
    - [x] Stack
    - [x] Queue
- [ ] Trees
    - [x] General Tree Structure
    - [ ] Heap
    - [ ] Binary Search Tree
    - [ ] Red-black Tree
- [ ] Graph
    - [ ] Adjacency Matrix
    - [ ] Adjacency List
    - [ ] Dijkstra's algorithm

## Setup

Simply clone the project, change into its directory, and run `mix` to compile
it.

```
$ git clone git@github.com:jmcdonald-ut/structured.git
$ cd structured
$ mix
```

Some useful commands are shown below:
```
$ mix test # Runs the test suite
$ mix credo # Style guide/consistency enforcer
$ iex -S mix # Provides the `Structured` module in the interactive elixir shell.
```

## Tuples vs. Lists

I was initially going to implement binary search for a list but I chose not to.
Since lists are implemented as linked lists in elixir, accessing an arbitrary
element exhibits `O(N)` behavior. Tuples allow a value to be accessed with
`O(1)` behavior, and so I have chosen to implement the binary search with the
tuple structure instead.

You can read more about tuples and lists via the [excellent elixir "Getting Started" guide](https://elixir-lang.org/getting-started/basic-types.html#lists-or-tuples).
