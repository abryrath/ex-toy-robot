defmodule ToyRobot.TableTest do
  use ExUnit.Case, async: true

  setup do
    table = start_supervised!(ToyRobot.Table)
    %{table: table}
  end

  test "Position starts at 0,0", %{table: table} do
    {:ok, {0, 0}} = ToyRobot.Table.pos(table)
    # GenServer.call(table, {:pos})
  end

  test "Direction is starts at north", %{table: table} do
    {:ok, 0} = ToyRobot.Table.dir(table)
    # GenServer.call(table, {:dir})
  end
end
