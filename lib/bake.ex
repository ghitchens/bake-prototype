defmodule Bake do

  require Logger

  @bake_dir "_bake"
  @build_server "swirl.telo.io"
  @build_user "build"
  @identity_uri "http://#{@build_server}/public_identity" 
  
  def init do 
    unless File.exists?("Bakefile") do
      Logger.error "no Bakefile"
      Logger.flush()
      :erlang.halt(1)
    end
    File.mkdir_p!(@bake_dir)
    init_uuid
    init_identity
  end

  def sync_out do
    rsync ".", remote_project_path
  end

  def build(args \\ "") do
    rcmd "bake-build #{project_id} $args"
  end
  
  def rsync(from, to) do
    Logger.info "syncing project"
    Logger.debug "syncing '#{from}' to '#{to}'"
    System.cmd "rsync", [ "-rltDz", "-e", "ssh -i #{identity_file}", from, to ]
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
      [remote_login, "-i", identity_file, "-C", "#{remote_cmd}", ],
      stderr_to_stdout: true,
      into: IO.stream(:stdio, :line)
  end

  def project_id, do: Process.get(:uuid)
  
  defp init_uuid do
    if File.exists?(uuid_file) do
      uuid = File.read!(uuid_file) |> String.strip
      Process.put :uuid, uuid
    else
      uuid = UUID.uuid1()
      File.write!(uuid_file, uuid)
      Process.put :uuid, uuid
    end
  end
  
  defp init_identity do
    unless File.exists?(identity_file) do
      Logger.debug "no identity file, requesting one"
      response = HTTPotion.get @identity_uri
      200 = response.status_code
      identity = response.body
      File.write!(identity_file, identity)
      File.chmod identity_file, 0o600
    end
    #System.cmd "ssh-add", [identity_file]
  end
  
  defp identity_file, do: Path.join(@bake_dir, ".bake_key")
  defp uuid_file, do: Path.join(@bake_dir, ".bake_uuid")  

end
