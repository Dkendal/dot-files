function docker-tags -a image
  set -l url "https://registry.hub.docker.com/v2/repositories/library/" image "/tags?page_size=1000"
  curl --silent $url | jq -r ".results[].name" | sort --version-sort
end
