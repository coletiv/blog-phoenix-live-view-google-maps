defmodule LiveViewGoogleMapsWeb.Maps do
  require Logger

    @topic inspect(__MODULE__)

  @moduledoc """
  The Channel process for map messages.
  """

  @doc """
    Subscribe to the topic/channel

    ## Examples

        iex> LiveViewGoogleMapsWeb.Maps.subscribe()
        [_]
  """
  def subscribe(topic \\ @topic) do
    Phoenix.PubSub.subscribe(LiveViewGoogleMaps.PubSub, topic)
  end

  @doc """
  Push params to the topic/channel

  ## Examples

  iex> LiveViewGoogleMapsWeb.Maps.metrics()
  [_]
  """
  def broadcast(params \\ {:error, "params are empty"}) do
    params
    |> notify_subscribers([:sightings, :updated])
  end

  def broadcast_one(params \\ {:error, "params are empty"}) do
    params
    |> notify_subscribers([:new_sighting, :created])
  end

  defp notify_subscribers({:ok, result}, event) do
      Logger.info "notifying subscribers of : "<> @topic <> " " <> result
    Phoenix.PubSub.broadcast(LiveViewGoogleMaps.PubSub, @topic, {__MODULE__, event, result})
    {:ok, result}
  end

  defp notify_subscribers({:error, reason}, _event), do: {:error, reason}
end
