defmodule Local do

  @moduledoc """
  Contains functions that are invoked by commands that perform locally
  initiated action (they don't just run a script on the server, in contrast
  to remote commands, which just run a script on the server)
  """
  
  require Logger

  def push(ctx), do: Remote.push(ctx)

  def pull(ctx, "-a"), do: Remote.sync_in(ctx, "_images")
  def pull(ctx, ext) do
    lext = String.downcase ext
    File.mkdir_p "_images"
    Remote.sync_in ctx, "_images/*.#{lext}", "_images/"
    ctx   
  end

  def burn(ctx, device_id), do: Burn.burn(ctx, device_id)

end