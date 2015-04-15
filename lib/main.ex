defmodule Main do

  def main([]), do: main(["help"])
  def main(["help"]), do: Cmd.Help.run

  def main(["build"]), do: Cmd.Build.run

  def main(other) do
		cmd = Enum.join(other, " ")
		IO.write "invalid or malformed command: #{cmd}\n"
	end

end
