defmodule TestBWeb.PageController do
  use TestBWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
