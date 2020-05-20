defmodule PersonalLibrary.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :title, :string
      add :author, :string
      add :classification, :string
      add :isbn, :string

      timestamps()
    end

  end
end
