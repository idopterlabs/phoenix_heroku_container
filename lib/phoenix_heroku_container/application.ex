defmodule PhoenixHerokuContainer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PhoenixHerokuContainerWeb.Telemetry,
      PhoenixHerokuContainer.Repo,
      {DNSCluster, query: Application.get_env(:phoenix_heroku_container, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PhoenixHerokuContainer.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PhoenixHerokuContainer.Finch},
      # Start a worker by calling: PhoenixHerokuContainer.Worker.start_link(arg)
      # {PhoenixHerokuContainer.Worker, arg},
      # Start to serve requests, typically the last entry
      PhoenixHerokuContainerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoenixHerokuContainer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhoenixHerokuContainerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
