Bake
====

__Bake__ is a command line tool which automates the process of bulding cross-compiled firmware using the bakeware.io cross compile toolchain. Getting started with Bake is easy:

1. Install the `bake` command line utility
2. Make sure your project has a `Bakefile`
3. type `bake build` and sit back and watch things build

## Installing the utiltiy

The mix.exs script installs the executable as as /usr/local/bin/bake.

If your user has write access to /usr/local/bin, you can simply:

    mix escript.build

If this gives you permissions error, either grant yourself group or user write permission access to /usr/local/bin, or run it as sudo.

## Configuration

In order to use `bake`, you will first need to add a `Bakefile` to your project, which looks like this:

```Makefile
project_type = nerves
sdk_config = alix
device_id = my_project_id
nerves_target = my_project_id
```

Bakefiles are configuration files for the bake process, and follow Makefile syntax rules.   See Bakeware.io for more information about the format and use of this file.

## Using `bake`

Once your project has a properly configured `Bakefile`, you are ready to do some baking.   Here are some examples of how to use bake:

    bake build fw         # builds firmware and downloads .fw file
    bake build img        # builds firmware and downloads .img file
    bake burn sd3         # burns downloaded img file to sd3

The arguments to bake are evaluated in sequence, so you can build a single command line that performs multiple functions.  Here is the output of `bake help` to give you an idea of what is possible:
    
    bake build <ext>|-a   alias for: sync start watch fetch <ext>|-a
    bake detach           alias for: sync start
    
    bake push             push (sync) source project to server
    bake start            begin a build of code on server and detach
    bake stop             stop a bake that is currently in progress
    bake status           show the status of a build
    bake watch            watch a build until while it completes
    bake clean            remove a project directory from the server
    bake pull <ext>       sync-in built firmware file or media image
    bake pull -a          pull all built firmware (zip files and images)
    bake burn <device>    burn a built image onto cf or sd card
    bake help             get this summary of commands

    Parameter Descriptions:
    
    <ext>       Extension of files to match for pull (usually `fw` or `img)
    <device>    The device to burn firmware to, e.g. `sd2` for /dev/sd2
