defmodule EasyDropbox.Dropbox.ClientTest do
  use ExUnit.Case

  alias EasyDropbox.Dropbox.Client

  setup do
    Agent.start_link(fn -> nil end, name: :token_repository)
    :ok
  end

  test "fetch ebooks from folder" do
    ebooks = Client.fetch_ebooks()
    assert Enum.count(ebooks) > 0
  end

end
