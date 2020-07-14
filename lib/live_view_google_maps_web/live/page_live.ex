defmodule LiveViewGoogleMapsWeb.PageLive do
  use LiveViewGoogleMapsWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("add_random_sighting", _params, socket) do
    random_sighting = generate_random_sighting()

    # inform the browser / client that there is a new sighting
    {:noreply, push_event(socket, "new_sighting", %{sighting: random_sighting})}
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
