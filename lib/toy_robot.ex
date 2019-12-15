defmodule ToyRobot do
  use Application

  @impl true
  def start(_type, _args) do
    ToyRobot.TableSupervisor.start_link(name: ToyRobot.TableSupervisor)
  end
end
