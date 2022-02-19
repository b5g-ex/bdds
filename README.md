# Bdds

If you want to use bdds,
**YOU FIRST NEED TO INSTALL [cyclonedds](https://github.com/eclipse-cyclonedds/cyclonedds) ON THE OS YOU WANT TO COMPILE IT ON.**

If you are interested in the reason, read this [issue](https://github.com/b5g-ex/bdds/issues/1).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `bdds` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bdds, "~> 0.0.1"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/bdds](https://hexdocs.pm/bdds).


## Use with pure Elixir Project

Just compile with env, DDS_INSTALL_DIR(=/usr/local is default) like below

```
# If you installed cyclonedds to /usr/local, you don't need to specify DDS_INSTALL_DIR.
$ DDS_INSTALL_DIR=/usr mix deps.compile
```

## Use with Nerves Project

Just install bdds by adding to deps.
Then specify `MIX_TARGET`, make firmware like below

```
# This command cross compile cyclonedds and install it to Nerves firmware.
$ MIX_TARGET=rpi4 mix firmware
```

