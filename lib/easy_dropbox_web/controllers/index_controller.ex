defmodule EasyDropboxWeb.IndexController do
  use EasyDropboxWeb, :controller

  require Logger

  def index(conn, _params) do
    ebooks = EasyDropbox.Dropbox.Client.fetch_ebooks()
    token = EasyDropbox.Dropbox.Client.valid_token()
    render(
      conn,
      "index.html",
      ebooks: ebooks |> add_encoded_download_arg() |> sort_by_server_modified_date(),
      authorizationHeader: "Bearer #{token}"
    )
  end

  def download(conn, params) do
    Logger.info("Downloading with " <> inspect(params))
    redirect(conn, external: "link-here")
  end

  defp add_encoded_download_arg(ebooks) do
    ebooks
    |> Enum.map(fn e ->
      encoded_download_arg = URI.encode(~s({"path":"#{e["id"]}"}))
      Map.put(e, "encoded_download_arg", encoded_download_arg)
    end)
  end

  defp sort_by_server_modified_date(ebooks) do
    ebooks
    |> Enum.sort(fn e1, e2 ->
      DateTime.compare(e1["server_modified"], e2["server_modified"]) != :lt
    end)
  end

end
