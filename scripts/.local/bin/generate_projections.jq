#!/usr/bin/env jq -Mf

def replaceString(comp):
	gsub("\\$COMPONENT"; comp);

def doWalk(s):
	if type == "string" then
		replaceString(s)
	elif type == "object" then
		with_entries(.key |= replaceString(s))
	else
		.
	end;

. as $source
| ["checkouts/core", "checkouts/web", "checkouts/api"]
| map
	(. as $comp
	| $source
	| walk(doWalk($comp))
	)
| add

