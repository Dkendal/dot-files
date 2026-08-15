function claudes --wraps="claude"
	claude --system-prompt="$(serena prompts print-cc-system-prompt-override)" $argv;
end
