defmodule TowerHoneybadger.ErrorTestPlug do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/runtime-error" do
    raise "error"

    send_resp(conn, 200, "OK")
  end

  get "/uncaught-throw" do
    throw("from inside a plug")

    send_resp(conn, 200, "OK")
  end

  get "/abnormal-exit" do
    exit(:abnormal)

    send_resp(conn, 200, "OK")
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
