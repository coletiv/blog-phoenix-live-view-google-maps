defmodule LiveViewGoogleMapsWeb.PageLive do
  use LiveViewGoogleMapsWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"action" => :add_random_sighting}, _params, _socket) do
    random_sighting = generate_random_sighting()

    # push the data to the genserver
    LiveViewGoogleMapsWeb.Server.add(random_sighting)
    {:noreply, [], %{sighting: random_sighting}}
  end


  def handle_params(_params, _uri, socket) do
    socket = assign(socket, :sightings, LiveViewGoogleMapsWeb.Server.show())

    if connected?(socket),
      do: LiveViewGoogleMapsWeb.Maps.subscribe("LiveViewGoogleMapsWeb.Maps")

    {:noreply, socket}
  end

  def handle_info({_requesting_module, [:sightings, :updated], data}, socket) do
    socket = assign(socket, :sightings, data)
    {:noreply, socket}
  end

  def handle_info({_requesting_module, [:new_sighting, :created], data}, socket) do
    socket = assign(socket, :new_sighting, data)
    {:noreply, socket}
  end

  defp generate_random_sighting() do
    %{
      latitude: Enum.random(-90..90),
      longitude: Enum.random(-180..180)
    }
  end
end
