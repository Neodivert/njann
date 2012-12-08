#!/bin/bash

###############################################################################
#`·.,¸,.·*¯`·.,¸,.·*·.╭━━━━━╮
#`·.,¸,.·*¯`·.,¸,.·*·.|:::::::/\__|\
#`·.,¸,.·*¯`·.,¸,.·*·╰|:::::::(◕ᴥ◕)
#`·.,¸,.·*¯`·.,¸,.-·*··u-u━━-u--u


# Not Just Another Name Normalizer "normalizes" the names of the files passed as arguments.
# Usage: njann [options] [files]

# Options:
# -r | --recursive: recursive
# -u | --uppercase: to uppercase
# -l | --lowercase: to lowercase
# -a | --ascii: to ascii
# -t | --test: test mode
# -v | --verbose: verbose mode
# --help: print help info 
###############################################################################


# ShowUsage function
###############################################################################
function ShowUsage()
{
	echo "Usage: njann [OPTION]... FILE..."
	echo "Try \`njann --help\` for more information"
}

# ShowHelp function
###############################################################################
function ShowHelp()
{
	echo "\`·.,¸,.·*¯\`·.,¸,.·*·.╭━━━━━━━╮"
	echo "\`·.,¸,.·*¯\`·.,¸,.·*·.|::::::::/\__|\\"
	echo "\`·.,¸,.·*¯\`·.,¸,.·*·╰|:::::::(◕ ᴥ ◕ )"
	echo "\`·.,¸,.·*¯\`·.,¸,.-·*··u-u━━━-u--u"
	echo ""
	echo "Usage: njann [OPTION]... FILE..."
	echo "Rename FILE according to options."
	echo "If no argument is specified renames to uppercase."	
	echo ""
	echo "   -r, --recursive                rename files recursively"
	echo "   -u, --uppercase                change file names to uppercase"
	echo "   -l, --lowercase                change file names to lowercase"
	echo "   -a, --ascii                    change file names to ascii only"
	echo "   -t, --test                     do not change the file names"
	echo "   -v, --verbose                  explain what is being done"
	echo "   -h, --help                     display this help and exit"
	echo ""
	echo "The options can be mixed in any way, but -l and -u can not be"
	echo "given together."
	echo ""
	echo "Exit status:"
	echo " 0  if no file name was/would be changed,"
	echo " 1  if some file name was/would be changed,"
	echo " 2  if there was some error."
	
}

# Normalization functions
###############################################################################
function Uppercase()
{
	res=$(echo "$1" | tr '[a-z]' '[A-Z]')
	res=$(echo "$res" | sed -e 's/á/Á/g;s/é/É/g;s/í/Í/g;s/ó/Ó/g;s/ú/Ú/g;s/ñ/Ñ/g;s/ç/Ç/g;s/ü/Ü/g;')
	echo "$res"
}

function UppercaseASCII()
{
	res=$(echo "$1" | tr '[a-z]' '[A-Z]')
	res=$(echo "$res" | sed -e 's/á/A/g;s/é/E/g;s/í/I/g;s/ó/O/g;s/ú/U/g;s/ñ/N/g;s/ç/C/g;s/Á/A/g;s/É/E/g;s/Í/I/g;s/Ó/O/g;s/Ú/U/g;s/Ñ/N/g;s/¡/!/g;s/¿/?/g;s/ü/U/g;s/Ü/U/g;s/Ç/C/g;')
	echo "$res"
}

function Lowercase()
{
	res=$(echo "$1" | tr '[A-Z]' '[a-z]')
	res=$(echo "$res" | sed -e 's/Á/á/g;s/É/é/g;s/Í/í/g;s/Ó/ó/g;s/Ú/ú/g;s/Ñ/ñ/g;s/Ç/ç/g;s/Ü/ü/g;')
	echo "$res"
}

function LowercaseASCII()
{
	res=$(echo "$1" | tr '[A-Z]' '[a-z]')
	res=$(echo "$res" | sed -e 's/á/a/g;s/é/e/g;s/í/i/g;s/ó/o/g;s/ú/u/g;s/ñ/n/g;s/ç/c/g;s/Á/a/g;s/É/e/g;s/Í/i/g;s/Ó/o/g;s/Ú/u/g;s/Ñ/n/g;s/¡/!/g;s/¿/?/g;s/ü/u/g;s/Ü/u/g;s/Ç/c/g;')
	echo "$res"
}

function ASCII()
{
	res=$(echo "$1" | sed -e 's/á/a/g;s/é/e/g;s/í/i/g;s/ó/o/g;s/ú/u/g;s/ñ/n/g;s/ç/c/g;s/Á/A/g;s/É/E/g;s/Í/I/g;s/Ó/O/g;s/Ú/U/g;s/Ñ/N/g;s/¡/!/g;s/¿/?/g;s/ü/u/g;s/Ü/U/g;s/Ç/C/g;')
	echo "$res"
}


# Other auxiliar functions
###############################################################################

# Auxiliar function for deleting a possible final slash in a dirname, so we
# don't have to worry about a dirname having it or no.
function DeleteFinalSlash()
{
	lastChar=$(echo "$1" | awk '{print substr($0,length,1)}' )
	if [ "$lastChar" = "/" ] ; then
		res="${1%?}"
	else
		res="$1"
	fi

	echo "$res"
}


# This function receives the following arguments:
# $1: file
# $2: transformation
# $3: recursive
# $4: test?
# Try to normalize "file" by applying transformation "transformation".
# If "recursive" is set to 1, apply transformation recursively.
# If "test" is set to 1, don't apply transformation, just inform whatever 
# file would't have been modified or not.
function NormalizeFile
{
	file="$1"
	transformation="$2"
	recursive="$3"
	test="$4"
	let return_value=0

	# Get the dirname and the basename of current file.
	dirname=${file%/*}
	dirname=$( DeleteFinalSlash "$dirname" )
	if [ "$dirname" = "$file" ] ; then
		# If file in the same directory that the script, $dirname would be
		# ./file, so change it.
		dirname="."
	fi
	basename=${file##*/}

	# Transform file name.
	# Check for permissions/existance of $file
	# $file can be a file, directory or link
	if [ -f "$file" ] || [ -d "$file" ] || [ -h "$file" ] ; then
		# Use transformation function on the file's basename
		new_basename=$( "$transformation" "$basename" )

		# Inform if file would be modified or not.
		if [ "$basename" != "$new_basename" ] ; then
			if [ "$test" = 0 ] ; then
				# This is not a test, rename the file.
				mv "$dirname/$basename" "$dirname/$new_basename"		
				# If there was an error changing the file name, then
				# we return error too
				if [ "$?" != 0 ] ; then
					let return_value=2
				fi								 
				file="$dirname/$new_basename"
			fi
			if [ "$verbose" = 1 ] ; then
				echo "$dirname/$basename -> $dirname/$new_basename";
			fi
			#If a file/directory is or would be modified return 1
			if [  "$return_value" != 2 ] ; then
				let return_value=1
			fi
		else
			if [ "$verbose" = 1 ] ; then
				echo "$dirname/$basename does not change"
			fi
		fi
	else
		echo "File ($file) does not exists" >&2
		# Or we don't have permissions.
	fi


	# If recursive option is set and $file is a directory, apply transformation
	# to its content.
	if [ "$recursive" = 1 ] && [ -d "$file" ] ; then
		file=$(DeleteFinalSlash "$file")

		if [[ -z $(ls -A "$file") ]] ; then
			#echo "El directorio ("$file") esta vacio"
			return
		fi

		for file2 in "$file"/*
		do
			NormalizeFile "$file2" "$transformation" "$recursive" "$test"
			# If there would be a modification inside the directory
			# make sure the script returns 1
			if [ "$?" = 1 ] && [  "$return_value" != 2 ] ; then
				let return_value=1
			fi
		done
	fi

	return "$return_value"
}


# Script main body
#################################################

#Getopt get with -o the short options, each char is an option, with -l long options
#with -n the name to print when an error occurs and -- the arguments to be processed
arguments=$(getopt -o rulatvh -l "recursive,uppercase,lowercase,ascii,test,verbose,help" -n "njann" -- "$@" )

# getopt returns a string in the form:
# -a -b ... --long1 ...  --longn -- 'arg1' ... 'argn'

let uppercase=0
let lowercase=0
let ascii=0
let recursive=0
let test=0
let verbose=0
let help=0
# 0 means no file was o would be modified
let return_value0
# Iterate through argument list until -- delimeter and count how many arguments are
let index=1
for k in $arguments
do
	(( index = index + 1 ))
	case "$k" in
		"-r"|"--recursive")
			recursive=1;;	
		"-u"|"--uppercase")
			uppercase=1;;
		"-l"|"--lowercase")
			lowercase=1;;	
		"-a"|"--ascii")
			ascii=1;;
		"-t"|"--test")
			test=1;;			
		"-v"|"--verbose")
			verbose=1;;		
		"-h"|"--help")
			help=1;;							
		"--")
			break;;				
	esac
done

if [ "$help" = 1 ] ; then
	ShowHelp
	exit 0
fi	 

# If no transformation is specified, use the "uppercase" option.
if [ "$uppercase" = 0 ] && [ "$lowercase" = 0 ] && [ "$ascii" = 0 ] ; then
	uppercase=1
fi

# Show an error message when user tries to uppercase and lowercase at the same 
# time.
if [ "$uppercase" = 1 ] && [ "$lowercase" = 1 ]
then
	echo "Do you realize I cannot change to uppercase and lowercase at the same time?" >&2
	exit 2
fi	

# File names are after the other arguments, so use index to retrieve the 
# substring with file names
files=$(echo "$arguments" | cut -d" " -f$index-)
# File names are 'name' 'name with spaces' 'other_name'

if [ "$files" = "--" ]
then
	# No file was given to the script
	ShowUsage >&2 
	exit 2
fi

# Fill the $transformation variable with the name of the correct transformation
# function
if [ "$uppercase" = 1 ] ; then
	if [ "$ascii" = 1 ] ; then
		transformation="UppercaseASCII"
	else
		transformation="Uppercase"	
	fi
elif [ "$lowercase" = 1 ] ; then
	if [ "$ascii" = 1 ] ; then
		transformation="LowercaseASCII"
	else
		transformation="Lowercase"
	fi
elif [ "$ascii" = 1 ] ; then
	transformation="ASCII"
fi

#echo "Operation: $transformation";

let k=2
file=$(echo "$files" | cut -d"'" -f2)
# Go through every file that was given as an argument
while [ "$file" != "" ]
do
	if [ "$file" != " " ] ; then
		file=$( DeleteFinalSlash "$file" )
		NormalizeFile "$file" "$transformation" "$recursive" "$test"
		return_value="$?"
	fi
	let k=k+1
	# Get next file or '
	file=$(echo "$files" | cut -d"'" -f"$k")
done	

exit $return_value


