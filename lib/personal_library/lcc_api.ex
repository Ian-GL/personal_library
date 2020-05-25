defmodule PersonalLibrary.LccApi do
  import SweetXml
  @api_url "http://classify.oclc.org/classify2/Classify?summary=true&"
  def get_lcc_by_isbn(isbn) do
    url = @api_url <> "isbn=" <> isbn
    api_call(url)
  end

  def get_lcc_by_owi(owi) do
    url = @api_url <> "owi=" <> owi
    api_call(url)
  end

  def api_call(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        process_lcc_response(body)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "API page not found"}
      {:error, %HTTPoison.Error{}} ->
        {:error, "Unexpected API error"}
    end
  end

  def process_lcc_response(lcc_response) do
    response_code = lcc_response |> xpath(~x"//response/@code"l) |> List.first |> to_string

    case response_code do
      "0" ->
        process_single_work(lcc_response)
      "4" ->
        first_owi = lcc_response |> xpath(~x"//works/work/@owi"l)

        if(first_owi) do
          first_owi
          |> List.first
          |> to_string
          |> get_lcc_by_owi
        else
          {:error, "Unable to get information between multiple works"}
        end

      "100" ->
        {:error, "No input. Please provide an ISBN to the API"}
      "101" ->
        {:error, "Error. The standard number argument is invalid"}
      "102" ->
        {:error, "Not found. No data found for the input argument."}
      "200" ->
        {:error, "Unexpected error on the classifier API"}
    end
  end
  def process_single_work(lcc_response) do
    title = lcc_response |> xpath(~x"//work/@title"l) |> List.first |> to_string
    author = lcc_response |> xpath(~x"//author/text()") |> to_string
    lcc = xpath(lcc_response, ~x"//lcc/mostPopular/@nsfa"l) |> List.first()

    if(lcc) do
      book_info =
        %{
          author: author,
          title: title,
          classification: lcc
        }

      {:ok, book_info}
    else
      {:error, "Unable to get book classification"}
    end
  end
end
