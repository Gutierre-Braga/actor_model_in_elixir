defmodule StackSupervisor do
  use Supervisor
  def start_link(_arg \\ []) do
    Supervisor.start_link __MODULE__, :ok, name: __MODULE__
  end
  def init(:ok) do
    children = [ProcessInElixir.StackNormal]
    Supervisor.init(children, strategy: :one_for_one)
  end
  def which_children(), do: Supervisor.which_children __MODULE__
end
