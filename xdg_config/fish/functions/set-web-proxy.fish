function set-web-proxy
	argparse -s 'on' 'off' -- $argv
	or return

	if set -q _flag_on
		networksetup -setsecurewebproxy 'Wi-Fi' 127.0.0.1 8080
		networksetup -setwebproxy 'Wi-Fi' 127.0.0.1 8080
		networksetup -setsecurewebproxystate 'Wi-Fi' on
		networksetup -setwebproxystate 'Wi-Fi' on
	else if set -q _flag_off
		networksetup -setsecurewebproxystate 'Wi-Fi' off
		networksetup -setwebproxystate 'Wi-Fi' off
	else
		echo 'Usage: set-web-proxy [--on|--off]'
	end
end
