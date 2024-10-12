defmodule Trails.Tracker do
  alias TrailsWeb.TrailsChannel
  alias TrailsWeb.Presence

  def create_name do
    UniqueNamesGenerator.generate([:adjectives, :animals])
  end

  def track_user(socket) do
    Presence.track(socket, socket.assigns.name, %{
      position: nil
    })
  end

  def untrack_user(socket) do
    Presence.untrack(socket, socket.assigns.name)
  end

  def update(socket, payload) do
    Presence.update(socket, socket.assigns.name, %{position: payload})
  end

  def get_users() do
    %{
      users:
        TrailsChannel.name()
        |> Presence.list()
        |> Map.to_list()
        |> Enum.map(fn {name, data} ->
          %{
            name: name,
            position: List.first(data.metas).position
          }
        end)
    }
  end
end
