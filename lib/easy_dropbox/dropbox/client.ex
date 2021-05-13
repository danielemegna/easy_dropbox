defmodule EasyDropbox.Dropbox.Client do

  require Logger

  def fetch_ebooks do
    token = refresh_token()
    ebooks = fetch_ebooks_with(token)
    {ebooks, token}
  end

  def download_ebook(id) do
    token = refresh_token()

    response = HTTPoison.post!(
      "https://content.dropboxapi.com/2/files/download",
      "",
      [
        {"Authorization", "Bearer #{token}"},
        {"Dropbox-API-Arg", "{\"path\": \"#{id}\"}"}
      ]
    )
    |> log_response()

    headers = response.headers
      |> Enum.filter(fn h ->
        match?({"Content-Length", _}, h) ||
        match?({"Content-Type", _}, h)
      end)

    %{
      byte_content: response.body,
      headers: headers
    }
  end

  defp fetch_ebooks_with(token) do
    HTTPoison.post!(
      "https://api.dropboxapi.com/2/files/list_folder",
      Jason.encode!(%{
        "path" => "/ebooks",
        "recursive" => true,
        "include_media_info" => false,
        "include_deleted" => false,
        "include_has_explicit_shared_members" => false,
        "include_mounted_folders" => false,
        "include_non_downloadable_files" => false,
      }),
      [
        {"Authorization", "Bearer #{token}"},
        {"Content-Type", "application/json"},
      ]
    )
    |> log_response()
    |> Map.get(:body)
    |> Jason.decode!()
    |> Map.get("entries")
    |> Enum.filter(&(Map.get(&1, ".tag") == "file"))
    |> Enum.map(&(Map.take(&1, ["id", "name", "path_display"])))
  end

  defp refresh_token do
    basic_auth_credentials = System.get_env("DROPBOX_APP_KEY") <> ":" <> System.get_env("DROPBOX_APP_SECRET")

    HTTPoison.post!(
      "https://api.dropbox.com/oauth2/token",
      {
        :multipart, [
          {"grant_type", "refresh_token"},
          {"refresh_token", System.get_env("DROPBOX_REFRESHABLE_TOKEN")}
        ]
      },
      [
        {"Authorization", "Basic #{Base.encode64(basic_auth_credentials)}"}
      ]
    )
    |> log_response()
    |> Map.get(:body)
    |> Jason.decode!()
    |> Map.get("access_token")
  end

  defp log_response(response) do
    Logger.debug(response)
    response
  end

end
