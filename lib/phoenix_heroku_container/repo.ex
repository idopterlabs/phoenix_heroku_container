defmodule PhoenixHerokuContainer.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_heroku_container,
    adapter: Ecto.Adapters.Postgres
end
