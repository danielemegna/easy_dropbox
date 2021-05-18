defmodule EasyDropboxWeb.IndexController do
  use EasyDropboxWeb, :controller

  def index(conn, _params) do
    ebooks = EasyDropbox.Dropbox.Client.fetch_ebooks()
    token = EasyDropbox.Dropbox.Client.valid_token()
    render(
      conn,
      "index.html",
      ebooks: ebooks |> add_encoded_download_arg(),
      authorizationHeader: "Bearer #{token}"
    )
  end

  defp add_encoded_download_arg(ebooks) do
    ebooks
    |> Enum.map(fn e ->
      encoded_download_arg = URI.encode(~s({"path":"#{e["id"]}"}))
      Map.put(e, "encoded_download_arg", encoded_download_arg)
    end)
  end

end
