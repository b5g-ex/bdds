defmodule Ddstest do
  @moduledoc """
  Documentation for `Ddstest`.
  """

  # defstruct handle: nil

  @doc """
  Hello world.

  ## Examples

      iex> Ddstest.hello()
      :world

  """
  def hello do
    :world
  end

  def create_publisher() do
    Ddstest.ddstest_create_publisher()
  end

  def create_subscriber() do
    Ddstest.ddstest_create_subscriber()
  end

  def delete() do
    Ddstest.ddstest_delete()
  end

  def sendmsg(msg) do
    Ddstest.ddstest_sendmsg(msg)
  end

  def test() do
    Ddstest.ddstest_test()
  end

  # @on_load :load_nif
  def load_nif do
    nif_file = Application.app_dir(:bdds, "priv/ddstest_nif")
    :erlang.load_nif(nif_file, 0)
  end

  def ddstest_create_publisher(), do: raise("NIF ddstest_create_publisher/0 not implemented")
  def ddstest_create_subscriber(), do: raise("NIF ddstest_create_subscriber/0 not implemented")
  def ddstest_sendmsg(_a), do: raise("NIF ddstest_sendmsg/1 not implemented")
  def ddstest_delete(), do: raise("NIF ddstest_delete/0 not implemented")
  def ddstest_test(), do: raise("NIF ddstest_test/0 not implemented")
end
