defmodule TrailsWeb.TrailsChannel do
  use TrailsWeb, :channel

  @impl true
  def join("trails:lobby", _payload, socket) do
    {:ok, :ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end
end
