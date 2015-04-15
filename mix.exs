defmodule Bake.Mixfile do
  
  use Mix.Project

  def project, do: [
    app: :bake,
    escript: [main_module: Main],
    version: "0.0.1",
    elixir: "~> 1.0",
    deps: deps
  ]

  def application, do: [
    applications: [:logger, :httpotion]
  ]

  defp deps, do: [
		{:exjsx, "~> 3.0.0" },
    {:uuid, "~> 1.0.0" },
		{:ibrowse, github: "cmullaparthi/ibrowse", tag: "v4.1.0"},
		{:httpotion, "~> 0.2.4"}
  ]

end
