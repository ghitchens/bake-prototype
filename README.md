Bake
====

A command line tool for building firmware using bakeware.io

## Installation

The mix.exs script installs the executable as as /usr/local/bin/bake.

If your user has write access to /usr/local/bin, you can simply:

    mix escript.build

If this gives you permissions error, either grant yourself group or user write permission access to /usr/local/bin, or add sudo before the command like this:

    sudo mix escript.build

## Usage

Add a __Bakefile__ to your project, which looks like this:

  project_type = nerves
  sdk_config = alix
  DEVICE_ID = my_project_id
  NERVES_TARGET = my_project_id

The file is makefile-syntax.  See Bakeware.io for more information about the format and use of this file.
