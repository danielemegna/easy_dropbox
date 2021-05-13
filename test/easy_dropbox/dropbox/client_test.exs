defmodule EasyDropbox.Dropbox.ClientTest do
  use ExUnit.Case

  alias EasyDropbox.Dropbox.Client

  test "fetch ebooks from folder" do
    {ebooks, token} = Client.fetch_ebooks()
    assert Enum.count(ebooks) > 0
    assert String.length(token) > 0
  end

  test "download ebooks with an id" do
    assert %{byte_content: byte_content, headers: headers} = Client.download_ebook("id:_Tm5Nio06KMAAAAAAAAChw")
    assert Enum.count(headers) == 2
    assert is_binary(byte_content)
    assert byte_size(byte_content) > 0
  end

end
