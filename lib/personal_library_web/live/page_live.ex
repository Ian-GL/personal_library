defmodule PersonalLibraryWeb.PageLive do
  use PersonalLibraryWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = redirect(socket, to: Routes.book_index_path(socket, :index))
    {:ok, socket}
  end
end
