defmodule Burn do
  
  require Logger
  
  def burn(context, device_id) do
    image_file = "_images/foo.img"
    media = Path.join "/dev", device_id
    umount_media media
    burn_file_to_media image_file, media
    Logger.info "waiting for bits to settle before eject"
    :timer.sleep 3000
    :ok = eject_media media
    context
  end

	def show_disk_options do
    {list, _} = System.cmd "diskutil", ["list"] 
    IO.write list
	end

	def disk_choice do
    show_disk_options
		IO.write "Burn to which disk #?"
		IO.read(1) |> String.downcase
	end

  def umount_media(media) do
		case System.cmd "diskutil", ["unmountDisk", media] do
      {_response, 0} -> 
        Logger.info "device unmounted"
        :ok
      _ -> 
        Logger.error "device failed to unmount"
        :error
    end
  end

 	def burn_file_to_media(file, media) do
    Logger.info "burning #{file} to #{media}"
    # System.cmd "osascript", ["-e", "do shell script \"dd if=#{file} of=#{media} bs=1m\" with administrator privileges"]
    System.cmd "dd", ["if=#{file}", "of=#{media}", "bs=1m"]
  end

	def eject_media(media) do
    Logger.info "ejecting #{media}"
		case System.cmd "diskutil", ["eject", media] do
			{_, 0} -> :ok
			_ -> :error
		end
	end
	
  def human_agrees_with_media_choice?(media, description) do
    IO.write "Assuming \"#{media}\", (#{description})\n"
    IO.write "    are you sure that is correct [y/N]?"
    case String.upcase(IO.read(1)) do
      "Y" -> true
      _ -> false
    end
  end
  
end
