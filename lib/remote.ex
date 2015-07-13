defmodule Remote do

  require Logger
  
  @moduledoc "Helpers for remote access, remote commands, and sync"
  
  @doc """
  invokes the oven script on the remote machine that is named bake-<cmd>, and
  copies the result to standard output.  This allows a fair number of 
  complicated behaviors and is used for starting, stopping builds, getting
  status of builds, cleaning, etc.
  """
  def oven(context, cmd) do
    rexec context, "oven #{cmd}"
    context
  end

  @doc """
  Push a copy of the source tree to the server.   Don't push the _images
  directory.   In the future, we might be able to specify excluded stuff
  """
  def push(context) do
    System.cmd "rsync", [ "-rltDz", "--exclude", "/_*", "-e",
  			"ssh -Aq -o StrictHostKeyChecking=no", ".", 
        (remote_path(context) <> "/") ]
    context
  end

  @doc "get a copy of the tree from the server"
  def sync_in(context, from, to \\ ".") do
    Logger.info "sync_in '#{from}' to '#{to}'"
    System.cmd "rsync", [ "-rltDz", "-e", "ssh -Aq -o StrictHostKeyChecking=no",
                          "#{remote_path(context)}/#{from}", to ]
    context
  end

  # execute remote command in the project directory
  @spec rexec(Map.t, String.t) :: Collectible.t
  defp rexec(context, cmd) do 
    System.cmd "ssh", [rlogin(context), "-ATq", "-o", 
      "StrictHostKeyChecking=no", "-C", rexec_cmd(context, cmd)], 
      stderr_to_stdout: true, into: IO.stream(:stdio, :line)
	end

  # returns bash cmd to find project dir then execute cmd
  defp rexec_cmd(context, cmd) do
    dir = project_dir(context)
    err = "missing project on server - try push first?"
    "if [ -d #{dir} ] ; then cd #{dir} ; #{cmd} ; else echo \"#{err}\" ; fi"
  end

  # returns ssh path like "user@oven.mydomain.com:projects/03f42251..."
  defp remote_path(context), do: "#{rlogin(context)}:#{project_dir(context)}"

  # returns a relative path to the project directory, eg projects/03f422155..
  defp project_dir(context), do: "projects/#{context.project_uuid}"

  # returns user@server.com if custom user, otherwise server.com
  defp rlogin(context) do
    if context[:build_user] do
      context.build_user <> "@" <> context.build_server
    else
      context.build_server
    end
  end

end
