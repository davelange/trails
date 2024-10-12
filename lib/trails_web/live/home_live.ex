defmodule TrailsWeb.HomeLive do
  alias TrailsWeb.TrailsChannel
  alias Trails.Tracker
  use TrailsWeb, :live_view

  def mount(_params, _session, socket) do
    TrailsWeb.Endpoint.subscribe(TrailsChannel.name())

    self_name = Tracker.create_name()

    updated =
      socket
      |> assign(users: exclude_self(Tracker.get_users().users, self_name), name: self_name)
      |> push_event("mount", %{name: self_name})

    {:ok, updated}
  end

  def handle_info(%{event: "presence_diff"}, socket) do
    {:noreply, socket}
  end

  def handle_info(%{payload: payload}, socket) do
    {:noreply, assign(socket, users: exclude_self(payload.users, socket.assigns.name))}
  end

  defp exclude_self(users, self) do
    Enum.filter(users, &(&1.name != self))
  end

  defp get_position(%{position: position}),
    do: "left: #{position["x"]}px; top: #{position["y"]}px"

  defp get_position(_user), do: ""

  def render(assigns) do
    ~H"""
    <div id={assigns.name} class="user" data-self>
      <%= assigns.name %>
    </div>
    <%= for user <- assigns.users do %>
      <div id={user.name} class="user" data-unset={is_nil(user.position)} style={get_position(user)}>
        <%= user.name %>
      </div>
    <% end %>
    """
  end
end
