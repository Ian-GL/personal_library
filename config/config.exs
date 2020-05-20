# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :personal_library,
  ecto_repos: [PersonalLibrary.Repo]

# Configures the endpoint
config :personal_library, PersonalLibraryWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Lz6r3Eg0jUAEP+rc4k6bn1Yk/irE0Xj8NAY/4gBX68cBVkRuF/UztD8WzcST2IqR",
  render_errors: [view: PersonalLibraryWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: PersonalLibrary.PubSub,
  live_view: [signing_salt: "86jOVHaU"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
