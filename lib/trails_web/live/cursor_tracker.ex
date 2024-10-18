defmodule TrailsWeb.CursorTracker do
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

  def handle_info(%{event: "user_update", payload: payload}, socket) do
    {:noreply,
     assign(socket, users: Tracker.exclude_self(payload.users, socket.assigns.user.name))}
  end

  def handle_info(_event, socket) do
    {:noreply, socket}
  end

  defp get_position(%{position: position}) do
    "left: #{position["x"]}%; top: #{position["y"]}%;"
  end

  defp get_position(_user), do: ""

  defp get_color(%{color: color}) do
    "color: #{color}; background: #{color}66"
  end

  def render(assigns) do
    ~H"""
    <div id={assigns.user.name} class="user" data-self>
      <div class="name self" style={get_color(assigns.user)}>
        <%= assigns.user.name %>
      </div>
    </div>
    <%= for user <- assigns.users do %>
      <div style={get_position(user)} class="user" data-unset={is_nil(user.position)}>
        <div id={user.name} class="name" style={get_color(user)}>
          <svg
            width="24px"
            height="24px"
            xmlns="http://www.w3.org/2000/svg"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            viewBox="0 0 21 21"
          >
            <polygon fill={user.color} points="9.2,7.3 9.2,18.5 12.2,15.6 12.6,15.5 17.4,15.5" />
          </svg>
          <%= user.name %>
        </div>
      </div>
    <% end %>
    <p class="info">(Click for confetti)</p>
    """
  end
end
