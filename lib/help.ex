defmodule Help do

  @help """

bake [cmds] - cook up cross-compiled firmware using the bakeware.io service

  bake build <ext>|-a   alias for: push start watch pull <ext>|-a
  bake detach           alias for: push start

  bake push             push (sync) source project to server
  bake start            begin a build of code on server and detach
  bake stop             stop a bake that is currently in progress
  bake status           show the status of a build
  bake peek             view a small portion of the bake log
  bake watch            watch a build until while it completes
  bake clean            remove a project directory from the server
  bake pull <ext>       sync-in built firmware file or media image
  bake pull -a          pull all built firmware (zip files and images)
  bake burn <device>    burn a built image onto cf or sd card
  bake help             get this summary of commands

Parameter Descriptions:

  <ext>       Extension of files to match for pull (usually `fw` or `img)
  <device>    The device to burn firmware to, e.g. `sd2` for /dev/sd2

Some simple examples:

  bake build fw         # builds firmware and downloads .fw file
  bake build img        # builds firmware and downloads .img file
  bake burn sd3         # burns downloaded img file to sd3

Arguments are evaluated in sequence, for compound commands like:

  bake clean build img burn sd3     # do a clean build and burn to /dev/sd3

"""

  def help do
    IO.write @help
  end
  
end