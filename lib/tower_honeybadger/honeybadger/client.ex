defmodule TowerHoneybadger.Honeybadger.Client do
  @api_key_header ~c"X-API-Key"

  def send(notice) do
    post("/notices", notice)
  end

  defp post(path, payload) when is_map(payload) do
    case :httpc.request(
           :post,
           {
             ~c"#{base_url()}#{path}",
             [{@api_key_header, api_key()}],
             ~c"application/json",
             TowerHoneybadger.json_module().encode!(payload)
           },
           [
             ssl: [
               verify: :verify_peer,
               cacerts: :public_key.cacerts_get(),
               # Support wildcard certificates
               customize_hostname_check: [
                 match_fun: :public_key.pkix_verify_hostname_match_fun(:https)
               ]
             ]
           ],
           []
         ) do
      {:ok, result} ->
        result

      {:error, reason} ->
        reason
    end
  end

  defp api_key do
    Application.fetch_env!(:tower_honeybadger, :api_key)
  end

  defp base_url do
    Application.fetch_env!(:tower_honeybadger, :honeybadger_base_url)
  end
end
