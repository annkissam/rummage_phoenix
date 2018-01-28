defmodule TestAWeb.PageController do
  use TestAWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
