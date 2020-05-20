# defmodule PersonalLibraryWeb.BookLive.BookConfirmation do
#   use PersonalLibraryWeb, :live_component
#   alias PersonalLibrary.LccApi
#   alias PersonalLibrary.Library.Book

#   @impl true
#   def mount(_params, _session, socket) do
#     {:ok, socket}
#   end

#   @impl true
#   def handle_event("get_lcc", %{"lcc_search" => %{"isbn" => ""}}, socket) do
#     socket = put_flash(socket, :error, "Please add a ISBN to search")
#     {:noreply, socket}
#   end

#   def handle_event("get_lcc", %{"lcc_search" => %{"isbn" => isbn}}, socket) do
#     case LccApi.get_lcc(isbn) do
#       {:ok, book} ->
#         book = Map.put(book, :isbn, isbn)
#         {:noreply, assign(socket, :book_confirmation, book)}

#       {:error, reason} ->
#         socket = put_flash(socket, :error, reason)
#         {:noreply, socket}
#     end
#   end
# end
