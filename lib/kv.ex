defmodule KV do
  def start_link,   do: Agent.start_link(&Map.new/0, name: __MODULE__)
  def get(id),      do: Agent.get(__MODULE__,    &(Map.get(&1, id, nil)))
  def put(id, val), do: Agent.update(__MODULE__, &(Map.put(&1, id, val)))
  def delete(id),   do: Agent.update(__MODULE__, &(Map.delete(&1, id)))
end