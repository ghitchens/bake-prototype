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
    rexec ctx, "bake-#{cmd} #{ctx.project_id}"
    ctx
  end

  def sync_in(ctx, from, to \\ ".") do
    sync(ctx, "#{rpath(ctx)}/#{from}", to)
    ctx
  end

  def sync_out(ctx, from, to \\ "") do
    sync(ctx, from, "#{rpath(ctx)}/#{to}")
    ctx
  end

  ############################### helpers ##################################


  @spec rexec(Map.t, String.t) :: Collectible.t
  defp rexec(ctx, remote_request) do 
    System.cmd "ssh", [rlogin(ctx), "-i", ctx.key_file, "-o",
  	                   "StrictHostKeyChecking=no", "-C", remote_request],
                stderr_to_stdout: true, into: IO.stream(:stdio, :line)
    ctx
  end

  defp sync(ctx, from, to) do
    Logger.debug "syncing '#{from}' to '#{to}'"
    System.cmd "rsync", [ "-rltDz", "-e",
  			"ssh -i #{ctx.key_file} -o StrictHostKeyChecking=no",
  												from, to ]
  end

  defp rpath(ctx) do
    "#{rlogin(ctx)}:projects/#{ctx.project_id}"
  end

  defp rlogin(ctx) do
    "#{ctx.build_user}@#{ctx.build_server}"
  end

end