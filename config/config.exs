# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :live_view_google_maps, LiveViewGoogleMapsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "64z8NQq29gm0mjhm8/5yWmGTAV7JqfWjGE3RZXgqI9jj1vfLkTOKsMJJlTV3ZUY1",
  render_errors: [view: LiveViewGoogleMapsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: LiveViewGoogleMaps.PubSub,
  live_view: [signing_salt: "SY69wEEb"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
