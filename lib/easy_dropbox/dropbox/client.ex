defmodule EasyDropbox.Dropbox.Client do

  def fetch_ebooks do
    token = refresh_token()
    fetch_ebooks_with(token)
  end

  defp fetch_ebooks_with(token) do
    url = "https://api.dropboxapi.com/2/files/list_folder"
    body = %{
      "path" => "/ebooks",
      "recursive" => true,
      "include_media_info" => false,
      "include_deleted" => false,
      "include_has_explicit_shared_members" => false,
      "include_mounted_folders" => false,
      "include_non_downloadable_files" => false,
    }
    headers = [
      {"Authorization", "Bearer #{token}"},
      {"Content-Type", "application/json"},
    ]

    response = HTTPoison.post!(url, Jason.encode!(body), headers)

    response.body
    |> Jason.decode!()
    |> Map.get("entries")
    |> Enum.map(&(Map.take(&1, ["id", "name", "path_display"])))
  end

  defp refresh_token do
    url = "https://api.dropbox.com/oauth2/token"
    body = {:multipart, [
      {"grant_type", "refresh_token"},
      {"refresh_token", System.get_env("DROPBOX_REFRESHABLE_TOKEN")}
    ]}
    credentials = System.get_env("DROPBOX_APP_KEY") <> ":" <> System.get_env("DROPBOX_APP_SECRET")
    headers = [{"Authorization", "Basic #{Base.encode64(credentials)}"}]

    response = HTTPoison.post!(url, body, headers)
    
    response.body
    |> Jason.decode!()
    |> Map.get("access_token")
  end

end
