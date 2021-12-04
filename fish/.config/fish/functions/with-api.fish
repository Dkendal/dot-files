function with-api -a url -a api
	switch "$api"
		case 'qa'
		string replace "https://cdn.builder.io/" "https://qa.builder.io/" "$url"

		case '*'
		string replace "https://cdn.builder.io/" "http://localhost:5000/" "$url"
	end
end
