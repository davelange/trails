defmodule TrailsWeb.HomeLive do
  alias TrailsWeb.TrailsChannel
  alias Trails.Tracker
  use TrailsWeb, :live_view

  def mount(_params, _session, socket) do
    TrailsWeb.Endpoint.subscribe(TrailsChannel.name())

    current_list = Tracker.get_users()

    {:ok, assign(socket, users: current_list.users)}
  end

  def handle_info(%{event: "presence_diff"}, socket) do
    {:noreply, socket}
  end

  def handle_info(%{payload: payload}, socket) do
    {:noreply, assign(socket, users: payload.users)}
  end

  defp get_position(%{position: position}),
    do: "left: #{position["x"]}px; top: #{position["y"]}px"

  defp get_position(_user), do: ""

  def render(assigns) do
    ~H"""
    <%= for user <- assigns.users do %>
      <div class="user" data-unset={is_nil(user.position)} style={get_position(user)}>
        <%= user.user_name %>
      </div>
    <% end %>
    """
  end
end
