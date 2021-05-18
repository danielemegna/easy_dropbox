defmodule EasyDropbox.Dropbox.Client do

  require Logger

  def fetch_ebooks do
    valid_token()
    |> fetch_ebooks_with()
  end

  def valid_token do
    stored_token = Agent.get(:token_repository, &(&1))
    if new_token_needed?(stored_token) do
      Logger.info("Obtaining new fresh token..")
      refresh_token() |> store_valid_token()
    else
      Logger.info("Using cached token..")
      stored_token.token
    end
  end

  defp fetch_ebooks_with(token) do
    Logger.info("Fetching ebooks..")
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

  defp new_token_needed?(nil), do: true
  defp new_token_needed?(actual), do: actual.expiration_date |> Timex.before?(Timex.now())

  defp store_valid_token(refresh_response) do
    %{"access_token" => token, "expires_in" => expiration_in_seconds} = refresh_response
    expiration_date = Timex.add(Timex.now(), Timex.Duration.from_seconds(expiration_in_seconds))
    Agent.update(:token_repository, fn _ -> %{token: token, expiration_date: expiration_date} end)
    token
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
  end

  defp log_response(response) do
    Logger.debug(response)
    response
  end

end
