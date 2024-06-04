defmodule Webaistuff.Repo do
  use Ecto.Repo,
    otp_app: :webaistuff,
    adapter: Ecto.Adapters.Postgres
end
