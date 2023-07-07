function builder-org -a id
	set -l db "/home/dylan/.local/share/builder/organizations.csv"
	trdsql -ih -ovf  'select * from "'$db'" where id = "'$id'"'
end
