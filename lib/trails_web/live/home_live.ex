defmodule TrailsWeb.HomeLive do
  alias TrailsWeb.TrailsChannel
  alias Trails.Tracker
  use TrailsWeb, :live_view

  def mount(_params, _session, socket) do
    TrailsWeb.Endpoint.subscribe(TrailsChannel.name())

    current_list = Tracker.get_users()

    {:ok, assign(socket, users: current_list.users)}
  end

  # ignore presence events
  def handle_info(%{event: "presence_diff"}, socket) do
    {:noreply, socket}
  end

  def handle_info(%{payload: payload, event: event}, socket) do
    IO.inspect(event)
    IO.inspect(payload)

    {:noreply, assign(socket, users: payload.users)}
  end

  def render(assigns) do
    ~H"""
    <%= for user <- assigns.users do %>
      <div class="user" style={"left: #{user.position["x"]}px; top: #{user.position["y"]}px"}>
        <%= user.user_name %>
      </div>
    <% end %>
    """
  end
end
