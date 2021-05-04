defmodule EasyDropboxWeb.PageController do
  use EasyDropboxWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
