defmodule Webaistuff.Repo.Migrations.CreateProviderForOauth do
  use Ecto.Migration

  def change() do
    alter table(:users) do
      add :provider, :string
      add :avatar_url, :string
    end
  end
end
