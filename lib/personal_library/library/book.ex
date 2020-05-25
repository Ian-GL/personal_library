defmodule PersonalLibrary.Library.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :author, :string
    field :classification, :string
    field :isbn, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :author, :classification, :isbn])
    |> validate_required([:title, :classification, :isbn])
    |> unique_constraint(:isbn)
  end
end
