defmodule WebaistuffWeb.UserLoginLive do
  use WebaistuffWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Log in to account
        <:subtitle>
          Don't have an account?
          <.link navigate={~p"/users/register"} class="font-semibold text-brand hover:underline">
            Sign up
          </.link>
          for an account now.
        </:subtitle>
      </.header>

      <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
        <.input field={@form[:email]} type="email" label="Email" required />
        <.input field={@form[:password]} type="password" label="Password" required />

        <:actions>
          <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
          <.link href={~p"/users/reset_password"} class="text-sm font-semibold">
            Forgot your password?
          </.link>
        </:actions>
        <:actions>
          <.button phx-disable-with="Logging in..." class="w-full">
            Log in <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
      <div class="py-4 flex flex-col gap-4">
        <div class="w-full text-center text-gray-500">or</div>
        <div class="flex gap-4 flex-col w-full">
          <.link navigate={~p"/auth/github"} class=
        "rounded-2xl py-2 px-3 border-2 border-black hover:bg-neutral-100 text-center text-sm font-semibold leading-6 ">
            Login with GitHub <.icon name="hero-github"/>
          </.link>
          <.link navigate={~p"/auth/google"} class=
        "rounded-2xl py-2 px-3 border-2 border-black hover:bg-neutral-100 text-center text-sm font-semibold leading-6 ">
            Login with Google <.icon name="hero-google"/>
          </.link>
          <.link navigate={~p"/auth/apple"} class=
        "rounded-2xl py-2 px-3 border-2 border-black hover:bg-neutral-100 text-center text-sm font-semibold leading-6 ">
            Login with Apple <.icon name="hero-apple"/>
          </.link>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
