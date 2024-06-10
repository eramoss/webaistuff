defmodule Webaistuff.Repo.Migrations.AddProviderUidToUsers do
  use Ecto.Migration

  def change() do
    alter table(:users) do
      add :provider_uid, :string
    end
  end
end
