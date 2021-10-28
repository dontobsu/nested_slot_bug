defmodule PlaygroundWeb.PlaygroundLive do
  use PlaygroundWeb, :live_view

  def outer_layout(assigns) do
    ~H"""
      <div>
        <%= render_slot(@inner_block) %>
      </div>
    """
  end

  def inner_layout(assigns) do
    ~H"""
      <.outer_layout>
        <%= render_slot(@inner_block) %>
      </.outer_layout>
    """
  end

  def render(assigns) do
    ~H"""
      <p>This does not update when form changes:</p>
      <.inner_layout>
        <.form let={form} for={@changeset} as="first" phx-change="change">
          <%= text_input form, :field %>
          Value: <%= input_value(form, :field) %>
        </.form>
      </.inner_layout>

      <p>This has other assigns and it updates normally:</p>
      <.inner_layout>

        <% @other_assign %>

        <.form let={form} for={@changeset} as="second" phx-change="change">
          <%= text_input form, :field %>
          Value: <%= input_value(form, :field) %>
        </.form>
      </.inner_layout>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(other_assign: true)
      |> assign_changeset()

    {:ok, socket}
  end

  def handle_event("change", params, socket) do
    params = params["first"] || params["second"]

    {:noreply, assign_changeset(socket, params)}
  end

  defp assign_changeset(socket, params \\ %{}) do
    changeset =
      {%{}, %{field: :string}}
      |> Ecto.Changeset.cast(params, [:field])

    assign(socket, changeset: changeset)
  end
end
