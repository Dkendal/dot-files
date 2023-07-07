function cf
	argparse --name=cf 'm/model=?' 'f/function=?' 'p/path=?' 'e/env=?' 'd/debug' 'a/auth' -- $argv

	set -l function $_flag_function
	set -l path $_flag_path
	set -l model $_flag_model
	set -l env $_flag_env

	set -l base_url ""

	if [ -z "$_flag_function" ]
		set function query
	end

	# Debug mode
	if [ -n "$_flag_debug" ]
		set -l debug true
		set argv $argv Fastly-Debug:1
	end

	switch "$env"
		case fs fast-staging
			set base_url http://fast-staging.builder.io.global.prod.fastly.net

		case f fast
			set base_url http://fast.builder.io

		case l local
			set base_url http://localhost:8080/$function

		case cr cloudrun
			set _flag_auth true
			set base_url https://query-3qimhwonqa-uc.a.run.app

		case tag test-api-gateway
			set base_url https://gateway-aqwq2hcu.uc.gateway.dev

		case ag api-gateway
			set base_url https://gateway-4e4t7239.uc.gateway.dev

		case cf cloudfunctions
			set base_url https://us-central1-builder-3b0a2.cloudfunctions.net/$function

		case '*' p production
			set env production
			set base_url https://cdn.builder.io
	end

	if [ -n "$_flag_model" ]
		set path "/api/v2/content/$model"
	end

	if [ -z "$path" ]
		set path (gum input --placeholder "/api/v2/content/pages")
	end

	set -l url "$base_url$path"

	if [ -z "$url" ]
		echo "Usage: cf [--model=<model>] [--function=<function>] [--path=<path>] [--env=<env>]"
		return 1
	end

	# Default apiKey is for the builder space
	if ! string match -eq apiKey $argv $url
		set argv $argv "apiKey==YJIGb4i01jvw0SRdL5Bt"
	end

	# Default limit is 10
	if ! string match -qe limit $argv $url
		set argv $argv "limit==10"
	end

	set -l http_args $url x-cdn-host:cdn.builder.io $argv

	if [ -n "$_flag_auth" ]
		set http_args $http_args Authorization:"Bearer "(gcloud auth print-identity-token)
	end

	gum style --height=3 --width=(tput cols) --faint (string join " " http $http_args)
	http $http_args
end
