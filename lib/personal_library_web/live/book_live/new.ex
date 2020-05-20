defmodule PersonalLibraryWeb.BookLive.New do
  use PersonalLibraryWeb, :live_view
  alias PersonalLibrary.LccApi
  alias PersonalLibrary.Library.Book

  @impl true
  def mount(_params, _session, socket) do
    assigns = %{
      book_confirmation: nil
    }
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_event("get_lcc", %{"lcc_search" => %{"isbn" => ""}}, socket) do
    socket = put_flash(socket, :error, "Please add a ISBN to search")
    {:noreply, socket}
  end

  def handle_event("get_lcc", %{"lcc_search" => %{"isbn" => isbn}}, socket) do
    # TODO: Get the expected id (last id + 1) to use as id
    case LccApi.get_lcc_by_isbn(isbn) do
      {:ok, book} ->
        book = Map.merge(book, %{isbn: isbn, id: 1})
        # book = Map.put(book, :isbn, isbn)
        book = struct(Book, book)
        {:noreply, assign(socket, :book_confirmation, book)}

      {:error, reason} ->
        socket = put_flash(socket, :error, reason)
        {:noreply, socket}
    end
  end
end
