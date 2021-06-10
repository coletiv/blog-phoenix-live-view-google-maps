defmodule LiveViewGoogleMapsWeb.Server do
  use GenServer
  require Logger

  @name __MODULE__

  defstruct data: []

  @doc """
  Show the state

  ## Examples

  iex> LiveViewGoogleMapsWeb.Server.show()
  [_]
  """
  def show() do
    try do
      GenServer.call(@name, :show)
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

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: @name)
  end


  @doc false
  def init(data) do

    initial_state = %{
      data: %{
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

    state = %{state|data: sightings}

## broadcast to subscribers
    LiveViewGoogleMapsWeb.Maps.broadcast({:ok,sightings})

    {:noreply, state}
  end

  @doc false
  def handle_call(:show, _, state) do
    {:reply, state, state}
  end


  def add(sighting) do
    GenServer.cast(@name, {:add, sighting})
  end
end
