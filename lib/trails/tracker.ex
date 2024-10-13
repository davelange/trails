defmodule Trails.Tracker do
  alias TrailsWeb.TrailsChannel
  alias TrailsWeb.Presence

  @colors ["#dc2626", "#d97706", "#16a34a", "#0d9488", "#0284c7", "#4f46e5", "#9333ea"]

  def create_name do
    UniqueNamesGenerator.generate([:adjectives, :animals], %{style: :capital, separator: " "})
  end

  def create_color() do
    Enum.random(@colors)
  end

  def track_user(socket) do
    Presence.track(socket, socket.assigns.name, %{
      position: nil,
      color: socket.assigns.color
    })
  end

  def untrack_user(socket) do
    Presence.untrack(socket, socket.assigns.name)
  end

  def update(socket, payload) do
    Presence.update(socket, socket.assigns.name, %{position: payload, color: socket.assigns.color})
  end

  def get_users() do
    %{
      users:
        TrailsChannel.name()
        |> Presence.list()
        |> Map.to_list()
        |> Enum.map(fn {name, data} ->
          Map.merge(List.first(data.metas), %{
            name: name
          })
        end)
    }
  end

  def exclude_self(list, self) do
    Enum.filter(list, &(&1.name != self))
  end
end
