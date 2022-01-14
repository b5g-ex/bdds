# Bdds

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `bdds` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bdds, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/bdds](https://hexdocs.pm/bdds).


## Use with pure Elixir Project

If you want to use bdds in a pure Elixir project,
**you first need to install [cyclonedds](https://github.com/eclipse-cyclonedds/cyclonedds)
on the OS you want to use it on.**

Then compile with env, DDS_INSTALL_DIR(=/usr/local is default) like below

```
# If you installed cyclonedds to /usr/local, you don't need to specify DDS_INSTALL_DIR.
$ DDS_INSTALL_DIR=/usr mix deps.compile
```

## Use with Nerve Project

You don't need to do nothing spetial, just install bdds by adding to deps.
Then specify `MIX_TARGET`, make firmware like below

```
# This command cross compile cyclonedds and install it to Nerves firmware.
$ MIX_TARGET=rpi4 mix firmware
```

