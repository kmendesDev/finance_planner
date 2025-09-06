defmodule FinancePlanner.Repo do
  use Ecto.Repo,
    otp_app: :finance_planner,
    adapter: Ecto.Adapters.Postgres
end
