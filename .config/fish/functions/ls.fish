# ls alias: human readable, show dotfiles, filetype indicators, color,
# directories first (if possible)

if [ (uname -s) = "Darwin" ] # If on OSX 
	if hash gls ^/dev/null # If GNU Coreutils installed
		function ls
			command gls -hAF --color --group-directories-first $argv
		end
	else
		function ls
			command ls -hAFG $argv
		end
	end
else 
	function ls
		command ls -hAF --color --group-directories-first $argv
	end
end
