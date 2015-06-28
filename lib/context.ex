defmodule Context do 

  require Logger
  
  @bakeinfo_file ".bakeinfo"
  @build_server "swirl.telo.io"
  @build_user "build"
  @identity_uri "http://#{@build_server}/public_identity" 
  
  @doc """
  Sets up the context for a series of bake commands by reading the bakeinfo
  file (if it exists) or creating one (if it doesn't)
  """
  def initialize do

    unless File.exists?("Bakefile") do
      raise "missing Bakefile"
    end
  
    project_id = if File.exists?(@bakeinfo_file) do
      puuid = File.read!(@bakeinfo_file) 
              |> String.split("\n", parts: 2, trim: true) 
              |> List.first 
              |> String.strip
      Logger.info "found existing project: #{puuid}"
      puuid
    else
      Logger.debug "setting up initial project identity/cache"
      response = HTTPotion.get @identity_uri
      200 = response.status_code
      uuid = UUID.uuid1()
      File.write! @bakeinfo_file, (uuid <> "\n" <> response.body)
      File.chmod @bakeinfo_file, 0o600
      uuid
    end
    
    %{  project_id:     project_id, 
        build_server:   @build_server, 
        build_user:     @build_user,
        key_file:       @bakeinfo_file  }
  end
 
end
