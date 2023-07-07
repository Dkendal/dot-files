function api -a url -a env -a cloudfunction
	if test -z $cloudfunction
		set cloudfunction "query"
	end

	switch $env
		case "dev"
			string replace 'https://cdn.builder.io' 'http://localhost:8080' $url |
			read url

		case "prod"
			string replace 'https://cdn.builder.io' "https://us-central1-builder-3b0a2.cloudfunctions.net/$cloudfunction" $url |
			read url

		case "qa"
			string replace 'https://cdn.builder.io' "https://us-central1-builder-io-qa.cloudfunctions.net/$cloudfunction" $url |
			read url
	end
	
	echo $url
end
