Bake
====

A command line tool for building firmware using bakeware.io

## Installation

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

