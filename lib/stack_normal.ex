defmodule ProcessInElixir.StackNormal do
  def start_link(initialStack \\ []) do
    pid = spawn_link __MODULE__, :loop, [initialStack]
    {:ok, pid}
  end
  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end
  def loop(stack \\ []) do
    receive do
      {:push, value} ->
        newStack = [value | stack]
        loop newStack
      {:pop, sender} ->
        [head | tail] = stack
        send sender, {:ok, head}
        loop tail
      {:show, sender} ->
        send sender, {:ok, Enum.reverse stack}
      {:raise} ->
        raise "error no processo"
    end
    loop stack
  end
  def push(pid, value), do: send pid, {:push, value}
  def raiseProcess(pid), do: send pid, {:raise}
  def pop(pid) do
    send pid, {:pop, self()}
    receive do {:ok, itemDeleted} -> itemDeleted end
  end
  def show(pid) do
    send pid, {:show, self()}
    receive do {:ok, stack} -> stack end
  end
end
