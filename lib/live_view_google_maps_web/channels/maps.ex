defmodule LiveViewGoogleMapsWeb.Maps do
  require Logger

    @topic inspect(__MODULE__)

  defstruct hash: nil

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
    Phoenix.PubSub.subscribe(LiveViewGoogleMapsWeb.PubSub, topic)
  end

  @doc """
  Push metrics to the topic/channel

  ## Examples

  iex> LiveViewGoogleMapsWeb.Maps.metrics()
  [_]
  """
  def new_sighting(params \\ {:error, "metrics are empty"}) do
    params
    |> notify_subscribers([:new_sighting, :updated])
  end

  defp notify_subscribers({:ok, result}, event) do
      Logger.info "notifying subscribers of : "<> @topic <> " " <> result
    Phoenix.PubSub.broadcast(LiveViewGoogleMapsWeb.PubSub, @topic, {__MODULE__, event, result})
    {:ok, result}
  end

  defp notify_subscribers({:error, reason}, _event), do: {:error, reason}
end
