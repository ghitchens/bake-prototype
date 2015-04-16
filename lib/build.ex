defmodule Cmd.Build do
  
  def run do
    Bake.init
    Bake.sync_out
    Bake.build
    Bake.sync_built_images_in
  end
  
end