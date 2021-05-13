defmodule EasyDropbox.Dropbox.ClientTest do
  use ExUnit.Case

  alias EasyDropbox.Dropbox.Client

  test "fetch ebooks from folder" do
    {ebooks, token} = Client.fetch_ebooks()
    assert Enum.count(ebooks) > 0
    assert String.length(token) > 0
  end

end
