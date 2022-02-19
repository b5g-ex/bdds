defmodule Bdds.MixProject do
  use Mix.Project

  @github_organization "b5g-ex"
  @app :bdds
  @source_url "https://github.com/#{@github_organization}/#{@app}"
  @version Path.join(__DIR__, "VERSION") |> File.read!() |> String.trim()

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      docs: docs(),
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
      {:elixir_make, "~> 0.6", runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    Bindings for DDS
    """
  end

  defp docs do
    [
      extras: ["README.md", "CHANGELOG.md"],
      main: "readme",
      source_ref: "v#{@version}",
      source_url: @source_url,
      skip_undefined_reference_warnings_on: ["CHANGELOG.md"]
    ]
  end

  defp package do
    [
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp make_targets(:host), do: ["install-dds-app"]
  defp make_targets(_), do: ["all"]

  defp make_clean(:host), do: ["clean-dds-app"]
  defp make_clean(_), do: ["clean"]
end
