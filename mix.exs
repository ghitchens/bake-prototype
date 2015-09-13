defmodule Bake.Mixfile do
  
  use Mix.Project

  def project, do: [
    app: :bake,
    escript: [main_module: Main, name: "bake", path: "/usr/local/bin/bake"],
    version: "0.2.0",
    elixir: "~> 1.0",
    deps: deps
  ]

  def application, do: [
    applications: [:logger, :httpotion]
  ]

  defp deps, do: [
    {:conform, "~> 0.17.0"},
		{:exjsx, "~> 3.2.0" },
    {:uuid, "~> 1.0.1" },
		{:ibrowse, github: "cmullaparthi/ibrowse", tag: "v4.1.2"},
		{:httpotion, "~> 2.1.0"}
  ]

end
