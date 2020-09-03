defmodule LiveViewGoogleMapsWeb.Server do
  use GenServer
  require Logger

  @registry_name :maps
  @name __MODULE__

  defstruct hash: nil,
            data: []




  @doc """
  Show the state

  ## Examples

  iex> LiveViewGoogleMapsWeb.Server.show()
  [_]
  """
  def show(hash) do
    try do
      GenServer.call(via_tuple(hash), :show)
    catch
      :exit, _ -> {:error, "not found"}
    end
  end


  @doc false
  def child_spec(args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [args]},
      type: :worker
    }
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args.data, name: via_tuple(args.data["Name"]))
  end

  @doc false
  def init(data) do

    initial_state = %{
      data: %{
        "Name" => data["Name"]
      }
    }

    {:ok, initial_state}
  end


  @doc false
  def handle_cast(:show, state) do
    {:noreply, state}
  end

  @doc false
  def handle_cast({:add, sighting}, state) do
    sightings = state.data["sightings"] + sighting
    Map.update(state.data, "sightings", sightings)
    state = %{state|data: state.data}

    LiveViewGoogleMapsWeb.Maps.new_sighting(sighting, nil, state.hash)

    {:noreply, state}
  end

  @doc false
  def handle_call(:show, _, state) do
    {:reply, state, state}
  end

  @doc false
  def via_tuple(hash, registry \\ @registry_name) do
    {:via, Registry, {registry, hash}}
  end

  def add(hash, sighting) do
    GenServer.cast(via_tuple(hash), {:add, sighting})
  end
end
