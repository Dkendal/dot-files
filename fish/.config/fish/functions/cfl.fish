function cfl -a path
	set -l port $PORT

	if test -z $port
		set port 8080
	end

	echo http "http://localhost:$port$path" x-cdn-host:cdn.builder.io $argv[2..-1]
	curlie "http://localhost:$port$path" x-cdn-host:cdn.builder.io $argv[2..-1]
end
