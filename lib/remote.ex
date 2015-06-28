defmodule Remote do

  require Logger
  
  @moduledoc "Helpers for remote access, remote commands, and sync"
  
  @doc """
  invokes a script on the remote machine that is named bake-<cmd>, and
  copies the result to standard output.  This allows a fair number of 
  complicated behaviors and is used for starting, stopping builds, getting
  status of builds, cleaning, etc.
  """

  def bake_cmd(ctx, cmd) do
    rexec ctx, "bake-#{cmd} #{ctx.project_uuid}"
    ctx
  end

  @doc """
  Push a copy of the source tree to the server.   Don't push the _images
  directory.   In the future, we might be able to specify excluded stuff
  """
  def push(ctx) do
    System.cmd "rsync", [ "-rltDz", "--exclude", "/_*", "-e",
  			"ssh -qi #{ctx.key_file} -o StrictHostKeyChecking=no", ".", 
        (rpath(ctx) <> "/") ]
    ctx
  end
  
  def sync_in(ctx, from, to \\ ".") do
    Logger.info "sync_in '#{from}' to '#{to}'"
      System.cmd "rsync", [ "-rltDz", "-e",
            			"ssh -qi #{ctx.key_file} -o StrictHostKeyChecking=no",
                  "#{rpath(ctx)}/#{from}", to ]
    ctx
  end

  ############################### helpers ##################################


  @spec rexec(Map.t, String.t) :: Collectible.t
  defp rexec(ctx, remote_request) do 
    System.cmd "ssh", [rlogin(ctx), "-qi", ctx.key_file, "-o",
  	                   "StrictHostKeyChecking=no", "-C", remote_request],
                stderr_to_stdout: true, into: IO.stream(:stdio, :line)
    ctx
  end

  defp rpath(ctx) do
    "#{rlogin(ctx)}:projects/#{ctx.project_uuid}"
  end

  defp rlogin(ctx) do
    "#{ctx.build_user}@#{ctx.build_server}"
  end

end