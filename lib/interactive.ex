defmodule ToyRobot.Interactive do
  @behaviour Ratatouille.App

  import Ratatouille.View

  def init(_context) do
    {:ok, table} = GenServer.start_link(ToyRobot.Table, :ok)
    table
  end


end
