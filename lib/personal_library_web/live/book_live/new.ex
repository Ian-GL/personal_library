defmodule PersonalLibraryWeb.BookLive.New do
  use PersonalLibraryWeb, :live_view
  alias PersonalLibrary.LccApi
  alias PersonalLibrary.Library
  alias PersonalLibrary.Library.Book

  @impl true
  def mount(_params, _session, socket) do
    # last_id = Library.get_last_book_id() || 0

    # assigns = %{
    #   book_confirmation: nil,
    #   new_id: last_id + 1
    # }
    {:ok, socket}
  end

  @impl true
  def handle_event("get_lcc", %{"lcc_search" => %{"isbn" => ""}}, socket) do
    socket = put_flash(socket, :error, "Please add a ISBN to search")
    {:noreply, socket}
  end

  def handle_event("get_lcc", %{"lcc_search" => %{"isbn" => isbn}}, socket) do
    case LccApi.get_lcc_by_isbn(isbn) do
      {:ok, book} ->
        book = Map.merge(book, %{isbn: isbn, id: socket.assigns.new_id})
        book = struct(Book, book)
        {:noreply, assign(socket, :book_confirmation, book)}

      {:error, reason} ->
        socket = put_flash(socket, :error, reason)
        {:noreply, socket}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    last_id = Library.get_last_book_id() || 0

    socket
    |> assign(:book_confirmation, nil)
    |> assign(:new_id, last_id + 1)
  end
end
