defmodule Bdds.MixProject do
  use Mix.Project

  def project do
    [
      app: :bdds,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      compilers: [:elixir_make | Mix.compilers()],
      make_targets: make_targets(Mix.target()),
      make_clean: make_clean(Mix.target())
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:elixir_make, "~> 0.6", runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp make_targets(:host), do: ["install-dds-app"]
  defp make_targets(_), do: ["all"]

  defp make_clean(:host), do: ["clean-dds-app"]
  defp make_clean(_), do: ["clean"]
end
