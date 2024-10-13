defmodule TrailsWeb.HomeLive do
  alias TrailsWeb.TrailsChannel
  alias Trails.Tracker
  use TrailsWeb, :live_view

  def mount(_params, _session, socket) do
    TrailsWeb.Endpoint.subscribe(TrailsChannel.name())

    self = %{
      name: Tracker.create_name(),
      color: Tracker.create_color()
    }

    updated =
      socket
      |> assign(users: Tracker.get_users().users, user: self)
      |> push_event("mount", self)

    {:ok, updated}
  end

  def handle_info(%{event: "presence_diff"}, socket) do
    {:noreply, socket}
  end

  def handle_info(%{event: "confetti"}, socket) do
    {:noreply, socket}
  end

  def handle_info(%{event: "user_update", payload: payload}, socket) do
    {:noreply,
     assign(socket, users: Tracker.exclude_self(payload.users, socket.assigns.user.name))}
  end

  defp get_style(%{position: position, color: color}),
    do:
      "left: #{position["x"]}px; top: #{position["y"]}px; color: #{color}; background: #{color}66"

  defp get_style(_user), do: ""

  def render(assigns) do
    ~H"""
    <div
      id={assigns.user.name}
      class="user"
      data-self
      style={"background-color: #{assigns.user.color}"}
    >
      <%= assigns.user.name %>
    </div>
    <%= for user <- assigns.users do %>
      <div id={user.name} class="user" data-unset={is_nil(user.position)} style={get_style(user)}>
        <%= user.name %>
      </div>
    <% end %>
    """
  end
end
