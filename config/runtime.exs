import Config

# Self-hosted (draconis) runtime config: plain HTTP behind a TLS-terminating, authenticated reverse proxy.
# PORT          listen port (default 4000)
# SECRET_KEY    Phoenix secret_key_base (required in prod)
# PHX_HOST      public hostname, used for URL generation
# CHECK_ORIGIN  comma-separated websocket origins, e.g. "//mahjong.draconis.io" (default: same as PHX_HOST)
if config_env() == :prod do
  host = System.get_env("PHX_HOST") || "localhost"
  origins =
    case System.get_env("CHECK_ORIGIN") do
      nil -> ["//" <> host]
      list -> String.split(list, ",", trim: true)
    end

  config :riichi_advanced, RiichiAdvancedWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      ip: {0, 0, 0, 0},
      port: String.to_integer(System.get_env("PORT") || "4000"),
      thousand_island_options: [transport_options: [reuseport: true]]
    ],
    server: true,
    check_origin: origins,
    debug_errors: false,
    secret_key_base: System.fetch_env!("SECRET_KEY")
end
