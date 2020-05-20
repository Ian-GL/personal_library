defmodule PersonalLibraryWeb.BookLive.Index do
  use PersonalLibraryWeb, :live_view

  alias PersonalLibrary.Library
  alias PersonalLibrary.Library.Book

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :books, fetch_books())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Book")
    |> assign(:book, Library.get_book!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Book")
    |> assign(:book, %Book{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Books")
    |> assign(:book, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    book = Library.get_book!(id)
    {:ok, _} = Library.delete_book(book)

    {:noreply, assign(socket, :books, fetch_books())}
  end

  defp fetch_books do
    Library.list_books()
    |> order_books_by_lcc
    # |> IO.inspect(label: "books")
  end

  defp order_books_by_lcc(books) do
    books
    |> Enum.sort(fn a, b ->
      a = dissect_lcc(a.classification)
      b = dissect_lcc(b.classification)

      compare_lcc_levels(a, b, "first")
    end)
  end

  def compare_lcc_levels(_a, _b, "third"), do: true
  def compare_lcc_levels(a, b, level) do
    next_level =
      case level do
        "first" -> "second"
        "second" -> "third"
        "third" -> nil
      end

    cond do
      a[level] < b[level] ->
        true

      a[level] == b[level] ->
        compare_lcc_levels(a, b, next_level)

      true -> false
    end
  end

  defp dissect_lcc(lcc) do
    captures = Regex.named_captures(~r/(?<first>.+?(?=[0-9]))(?<second>.+(?=\.)).(?<third>.+)/, lcc)
  end
end
