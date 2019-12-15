defmodule ToyRobot.Table do
  @moduledoc """
  GenServer for the Table Dimension and Robot position/direction state
  """
  use GenServer

  @typedoc """
  position: x, y
  """
  @type pos :: {integer, integer}

  # Client functions
  def pos(table), do: GenServer.call(table, {:pos})

  def dir(table), do: GenServer.call(table, {:dir})

  def move(table), do: GenServer.cast(table, {:move})

  def left(table), do: GenServer.cast(table, {:left})

  def right(table), do: GenServer.cast(table, {:right})

  @doc """
  Starts the registry.
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end


  # Server functions
  @impl true
  def init(:ok) do
    {:ok,
     %{
       dimensions: %{
         x: {0, 5},
         y: {0, 5}
       },
       pos: {0, 0},
       dir: 0
     }}
  end

  @impl true
  def handle_call({:pos}, _from, table) do
    {:reply, Map.fetch(table, :pos), table}
  end

  @impl true
  def handle_call({:dir}, _from, table) do
    # 0 - North
    # 1 - East
    # 2 - South
    # 3 - West
    {:reply, Map.fetch(table, :dir), table}
  end

  @impl true
  def handle_cast({:move}, table) do
    {:noreply, Map.put(table, :pos, move_p(table))}
  end

  @impl true
  def handle_cast({:right}, table) do
    {:ok, dir} = Map.fetch(table, :dir)
    {:noreply, Map.put(table, :dir, right_p(dir))}
  end

  @impl true
  def handle_cast({:left}, table) do
    {:ok, dir} = Map.fetch(table, :dir)
    {:noreply, Map.put(table, :dir, left_p(dir))}
  end

  defp right_p(3), do: 0
  defp right_p(n), do: n + 1

  defp left_p(0), do: 3
  defp left_p(n), do: n - 1

  defp move_p(table) do
    {:ok, dimensions} = Map.fetch(table, :dimensions)
    {:ok, pos} = Map.fetch(table, :pos)
    {:ok, dir} = Map.fetch(table, :dir)
    {x, y} = pos

    case valid_move?(dimensions, pos, dir) do
      true ->
        IO.puts("move is valid")

        case dir do
          0 -> {x, y + 1}
          1 -> {x + 1, y}
          2 -> {x, y - 1}
          3 -> {x - 1, y}
        end

      false ->
        IO.puts("move is invalid")
        {x, y}
    end
  end

  defp valid_move?(%{x: _, y: {_min_y, max_y}}, {_x, y}, 0), do: y + 1 <= max_y
  defp valid_move?(%{x: _, y: {min_y, _max_y}}, {_x, y}, 2), do: y - 1 >= min_y
  defp valid_move?(%{x: {_min_x, max_x}, y: _}, {x, _y}, 1), do: x + 1 <= max_x
  defp valid_move?(%{x: {min_x, _max_x}, y: _}, {x, _y}, 3), do: x - 1 >= min_x
  defp valid_move?(_dim, _pos, _n), do: false
end
