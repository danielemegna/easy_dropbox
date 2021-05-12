defmodule EasyDropboxWeb.IndexController do
  use EasyDropboxWeb, :controller

  def index(conn, _params) do
    ebooks = EasyDropbox.Dropbox.Client.fetch_ebooks()
    #ebooks = [
    #  %{
    #    "id"=> "id:_Tm5Nio06KMAAAAAAAAChw",
    #    "name"=> "Name here",
    #    "path_display"=> "/path"
    #  },
    #  %{
    #    "id"=> "wrongid",
    #    "name"=> "Another here",
    #    "path_display"=> "/another.path"
    #  }
    #]
    render(conn, "index.html", ebooks: ebooks, authorizationHeader: "Bearer QUI")
  end

  def download(conn, params) do
    IO.inspect(params)
    text(conn, "Ok !" <> inspect(params))
  end
end
