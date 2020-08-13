defmodule LiveViewGoogleMapsWeb.PageLive do
  use LiveViewGoogleMapsWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"hash" => hash, "action" => :add_random_sighting} , _params, _socket) do
    random_sighting = generate_random_sighting()

    # push the data to the genserver
    LiveViewGoogleMapsWeb.Server.add(hash, random_sighting)
    {:noreply, [], %{sighting: random_sighting}}
  end

    def handle_params(%{"hash" => hash}, _uri, socket) do

    socket = assign(socket, :new_sighting, LiveViewGoogleMapsWeb.Server.show(hash))
    if connected?(socket), do: LiveViewGoogleMapsWeb.Maps.subscribe("LiveViewGoogleMapsWeb.Maps", hash)
    {:noreply, socket}
  end


  def handle_info({_requesting_module, [:new_sighting, :updated], data}, socket) do
    socket = assign(socket, :new_sighting, data)
    {:noreply, socket}
  end


  defp generate_random_sighting() do
    # https://developers.google.com/maps/documentation/javascript/reference/coordinates
    # Latitude ranges between -90 and 90 degrees, inclusive.
    # Longitude ranges between -180 and 180 degrees, inclusive
    %{
      latitude: Enum.random(-90..90),
      longitude: Enum.random(-180..180)
    }
  end
end
