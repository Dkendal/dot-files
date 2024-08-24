function yarn-versions
	yarn info $argv --json | jq '.data.versions'
end
