defmodule FinancePlanner.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FinancePlannerWeb.Telemetry,
      FinancePlanner.Repo,
      {DNSCluster, query: Application.get_env(:finance_planner, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FinancePlanner.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: FinancePlanner.Finch},
      # Start a worker by calling: FinancePlanner.Worker.start_link(arg)
      # {FinancePlanner.Worker, arg},
      # Start to serve requests, typically the last entry
      FinancePlannerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FinancePlanner.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FinancePlannerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
