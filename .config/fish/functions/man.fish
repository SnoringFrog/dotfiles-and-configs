# Haven't tested this too thoroughly, so it might behave oddly for some edge
# cases. 

function man
	echo $argv[-1]
	set cmd_first_letter (echo $argv[-1] | cut -c1)
	echo $cmd_first_letter
	command man -M (brew --prefix)/opt/coreutils/libexec/gnuman $argv 1>/dev/null 2>&1
	if [ "$status" -eq 0 ]
		functions $argv[-1] | grep "g$argv[-1]" 1>/dev/null 2>&1 
		if [ "$status" -eq 0 ]
			command man -M (brew --prefix)/opt/coreutils/libexec/gnuman $argv 
		end
	else
		command man $argv
	end
end
