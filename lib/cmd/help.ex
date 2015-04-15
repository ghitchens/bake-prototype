defmodule Cmd.Help do

  @help """

  bake - cook up cross-compiled firmware using the bakeware.io service

  bake build                  build cross-compiled firmware
  bake fetch                  get the most recent build from the server
  bake burn                   burn the resulting firmware-image into a card
  bake help                   prints this message
  
  """
  
  def run, do: IO.write @help
  
end