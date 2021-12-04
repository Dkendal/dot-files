# Defined in - @ line 1
function relpath --description alias\ relpath=node\ -pe\ \'require\(\"path\"\).relative\(__dirname,\ process.argv\[1\]\)\'
	node -pe 'require("path").relative(__dirname, process.argv[1])' $argv;
end
