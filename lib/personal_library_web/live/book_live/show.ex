defmodule PersonalLibraryWeb.BookLive.Show do
  use PersonalLibraryWeb, :live_view

  alias PersonalLibrary.Library

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     # TODO: get book by classification
     |> assign(:book, Library.get_book!(id))}
  end

  defp page_title(:show), do: "Show Book"
  defp page_title(:edit), do: "Edit Book"
end
