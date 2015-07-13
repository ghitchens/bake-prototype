defmodule Context do 

  require Logger

  @bakefile_file "Bakefile"
  @bakeinfo_file ".bakeinfo"
  @build_server "swirl.telo.io"
  @build_user "build"

  @doc """
  Sets up the context for a series of bake commands by reading the bakeinfo
  file (if it exists) or creating one (if it doesn't)
  """
  def initialize do
    
    bakefile_path = Path.expand @bakefile_file
    unless File.exists?(bakefile_path), do: raise "missing Bakefile"
    raw_config = :conf_parse.file(bakefile_path)
    keylist_config = Enum.map raw_config, fn({[k],v}) ->
      {:erlang.list_to_atom(k),:erlang.list_to_binary(v)} 
    end
    bakefile_map = Dict.merge(%{}, keylist_config)
    unless bakefile_map[:project_id], do: raise "Bakefile has no project_id"
    
    project_uuid = if File.exists?(@bakeinfo_file) do
      puuid = File.read!(@bakeinfo_file) 
              |> String.split("\n", parts: 2, trim: true) 
              |> List.first 
              |> String.strip
      Logger.debug "found existing project: #{puuid}"
      puuid
    else
      uuid = UUID.uuid1
      File.write! @bakeinfo_file, (uuid <> "\n")
      uuid
    end
    
    Dict.merge bakefile_map, [ 
      project_uuid: project_uuid, build_server: @build_server
    ]

  end
 
end
