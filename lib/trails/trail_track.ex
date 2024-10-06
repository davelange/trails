defmodule Trails.TrailTrack do
  alias TrailsWeb.Presence

  def track_user(socket) do
    Presence.track(socket, socket.assigns.user_name, %{
      position: %{x: 0, y: 0}
    })
  end

  def untrack_user(socket) do
    Presence.untrack(socket, socket.assigns.user_name)
  end

  def update(socket, payload) do
    Presence.update(socket, socket.assigns.user_name, %{position: payload})
  end

  def get_users(socket) do
    socket
    |> Presence.list()
    |> Map.to_list()
    |> Enum.map(fn {user_name, data} ->
      %{user_name: user_name, position: List.first(data.metas).position}
    end)
  end
end
