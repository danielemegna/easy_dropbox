defmodule EasyDropboxWeb.IndexController do
  use EasyDropboxWeb, :controller

  def index(conn, _params) do
    ebooks = EasyDropbox.Dropbox.Client.fetch_ebooks()
    render(conn, "index.html", ebooks: ebooks)
  end

  def download(conn, params) do
    IO.inspect(params)
    text(conn, "Ok !" <> inspect(params))
  end
end
