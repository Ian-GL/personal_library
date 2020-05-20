defmodule PersonalLibrary.Repo do
  use Ecto.Repo,
    otp_app: :personal_library,
    adapter: Ecto.Adapters.Postgres
end
