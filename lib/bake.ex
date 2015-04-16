defmodule Bake do

  require Logger

  @bakeinfo_file ".bakeinfo"
  @build_server "swirl.telo.io"
  @build_user "build"
  @identity_uri "http://#{@build_server}/public_identity" 
  
  def init do 
    unless File.exists?("Bakefile") do
      Logger.error "no Bakefile"
      Logger.flush()
      :erlang.halt(1)
    end
    init_bakeinfo
  end

  def sync_out do
    Logger.info "syncing project to server"
    rsync ".", remote_project_path
  end

  def sync_built_images_in do
    Logger.info "getting images from server"
    rsync "#{remote_project_path}/_images", "."
  end

  def build(args \\ "") do
    Logger.info "building project"
    rcmd "bake-build #{project_id} $args"
  end
  
  def rsync(from, to) do
    Logger.debug "syncing '#{from}' to '#{to}'"
    System.cmd "rsync", [ "-rltDz", "-e", "ssh -i #{@bakeinfo_file}", from, to ]
  end
  
  def remote_project_path do
    "#{remote_login}:projects/#{project_id}"
  end

  def remote_login do
    "#{@build_user}@#{@build_server}"
  end
  
  @spec rcmd(String.t) :: Collectible.t
  def rcmd(remote_cmd) do 
    System.cmd "ssh", 
      [remote_login, "-i", @bakeinfo_file, "-C", "#{remote_cmd}"],
      stderr_to_stdout: true,
      into: IO.stream(:stdio, :line)
  end

  def project_id, do: Process.get(:project_id)
  
  defp init_bakeinfo do
    if File.exists?(@bakeinfo_file) do
      puuid = File.read!(@bakeinfo_file) 
              |> String.split("\n", parts: 2, trim: true) 
              |> List.first 
              |> String.strip
      Logger.info "found existing project: #{puuid}"
      Process.put :project_id, puuid
    else
      Logger.debug "setting up initial project identity/cache"
      response = HTTPotion.get @identity_uri
      200 = response.status_code
      uuid = UUID.uuid1()
      File.write! @bakeinfo_file, (uuid <> "\n" <> response.body)
      File.chmod @bakeinfo_file, 0o600
      Process.put :project_id, uuid
    end
  end
  
end
