defmodule Cmd.Build do
  
  def run do
    Bake.init
    Bake.sync_out
    Bake.build
  end
  
end