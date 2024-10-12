defmodule TrailsWeb.TrailsChannel do
  use TrailsWeb, :channel
  alias Trails.Tracker

  @name "trails:main"

  def name, do: @name

  @impl true
  def join(@name, _payload, socket) do
    send(self(), :after_join)

    {:ok, assign(socket, :user_name, Tracker.create_name())}
  end

  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  @impl true
  def handle_in("new_pos", payload, socket) do
    Tracker.update(socket, payload)
    broadcast(socket, "new_pos", Tracker.get_users())

    {:noreply, socket}
  end

  @impl true
  def handle_info(:after_join, socket) do
    Tracker.track_user(socket)
    broadcast(socket, "user_update", Tracker.get_users())

    {:noreply, socket}
  end

  @impl true
  def terminate({:shutdown, :local_closed}, socket) do
    Tracker.untrack_user(socket)
    broadcast(socket, "user_update", Tracker.get_users())

    {:noreply, socket}
  end

  @impl true
  def terminate(_reason, socket), do: socket
end
