defmodule Main do

  require Logger

  def main([]), do: main(["help"])
  def main(["help"]), do: Help.help
  def main(cmds) do
    try do
      parse(Context.initialize, cmds)
    rescue
      e in RuntimeError -> e
      Logger.error "#{e.message}"
    end
  end
    
  def parse(context, [cmd | rest]) do
    handle context, :erlang.binary_to_atom(String.downcase(cmd), :utf8), rest
  end

  def parse(_context, []) do
    Logger.debug "finished parsing & executing all tasks"
  end

  ## command handlers

  @local_cmds_0 [ :push, :detach ]
  @local_cmds_1 [ :pull, :burn, :build ]
  @remote_cmds  [ :start, :stop, :watch, :peek, :status, :clean ]

  defp handle(ctx, :build, [arg | rest]) do
    parse(ctx, ["push", "start", "watch", "pull", arg] ++ rest)
  end
  
  defp handle(ctx, :detach, rest) do
    parse(ctx, ["push", "start"] ++ rest)
  end

  defp handle(context, cmd, rest) when cmd in @local_cmds_0 do
    Logger.debug "#{cmd}"
    apply(Local, cmd, [context]) |> parse(rest)
  end

  defp handle(context, cmd, [arg | rest]) when cmd in @local_cmds_1 do
    Logger.debug "#{cmd} #{arg}"
    apply(Local, cmd, [context, arg]) |> parse(rest)
  end
  
  defp handle(context, cmd, rest) when cmd in @remote_cmds do
    Logger.debug "#{cmd} (remote):"
    Remote.bake_cmd(context, cmd) |> parse (rest)
  end
  
  defp handle(_context, cmd, _rest) do
    raise "unknown or malformed command: #{cmd}"
	end

end
