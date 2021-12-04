# Defined in - @ line 1
function chunkc-query-window --description alias\ chunkc-query-window\ watch\ \'chunkc\ tiling::query\ --window\ \$\(chunkc\ tiling::query\ --window\ id\)\'
	watch 'chunkc tiling::query --window $(chunkc tiling::query --window id)' $argv;
end
