function log-filter-errors
	sed -En '/^\*{10}/,/^\*{10}/ {
		s#'(pwd)'/vendor/bundle/ruby/2.5.0/bundler/gems#$bundler#
		s#'(pwd)'/vendor/bundle/ruby/2.5.0/gems#$gems#
		s#'(pwd)'#$#
		p
	}
	'
end
