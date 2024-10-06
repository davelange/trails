defmodule TrailsWeb.TrailsChannel do
  use TrailsWeb, :channel
  alias Trails.TrailTrack

  @impl true
  def join("trails:lobby", payload, socket) do
    send(self(), :after_join)

    {:ok, TrailTrack.get_users(socket), assign(socket, :user_name, payload["user_name"])}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  @impl true
  def handle_in("new_pos", payload, socket) do
    TrailTrack.update(socket, payload)

    broadcast(socket, "new_pos", %{
      position: payload,
      user_name: socket.assigns.user_name
    })

    {:noreply, socket}
  end

  @impl true
  def handle_info(:after_join, socket) do
    TrailTrack.track_user(socket)

    broadcast(socket, "user_update", %{action: "join", user_name: socket.assigns.user_name})

    {:noreply, socket}
  end

  @impl true
  def terminate({:shutdown, :local_closed}, socket) do
    TrailTrack.untrack_user(socket)

    broadcast(socket, "user_update", %{action: "leave", user_name: socket.assigns.user_name})

    {:noreply, socket}
  end

  @impl true
  def terminate(_reason, socket), do: socket
end
