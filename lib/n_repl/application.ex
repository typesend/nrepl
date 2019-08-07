defmodule NRepl.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: NRepl.Worker.start_link(arg)
      {NRepl.Worker, %{host: '127.0.0.1', port: 62592}}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NRepl.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
