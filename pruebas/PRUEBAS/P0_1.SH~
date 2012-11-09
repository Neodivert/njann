#!/bin/bash

# options 
# -r recursive
# -u to uppercase
# -l to lowercase
# -a to ascii
#Getopt get with -o the shortoptions, each char is an option, with -l longoptions
#with -n the name to print when an error occurs and -- the arguments to be processed
ARGUMENTS=$(getopt -o rula -l "recursive,uppercase,lowercase,ascii" -n "testprog.sh" -- "$@" )

#getopt returns a string in the form:
# -a -b ... --long1 ...  --longn -- 'arg1' ... 'argn'

#echo $ARGUMENTS
#exit

let index=1

#Iterate through argument list until -- delimeter
#and count how many arguments short and long arguments are
uppercase="0"
lowercase="0"
ascii="0"
recursive="0"
for k in $ARGUMENTS
do
	case $k in
		"-r"|"--recursive")
			echo "recursive found"
			recursive="1"
			(( index = index + 1 ));;	
		"-u"|"--uppercase")
			echo "uppercase found"
			uppercase="1"
			(( index = index + 1 ));;
		"-l"|"--lowercase")
			lowercase="1"
			echo "lowercase found"
			(( index = index + 1 ));;	
		"-a"|"--ascii")
			ascii="1"
			echo "ascii found"
			(( index = index + 1 ));;
		"--")
			(( index = index + 1 ))
			break;;				
	esac
done

#echo "argumentos = $ARGUMENTS"
#exit
if [ "$uppercase" = "1" ] && [ "$lowercase" = "1" ]
then
	echo "Do you realize I cannot change to uppercase and lowercase at the same time?" >&2
fi	

#File names are after the other arguments, so use index
#to retrieve the substring with file names
FILES=$(echo "$ARGUMENTS" | cut -d" " -f$index-)
#File names are 'name' 'name with spaces' 'other_name'

#echo "files vale $FILES"

if [ "$FILES" = "--" ]
then
	#No file was given to the script
	echo "Script usage is: script_name [options] file [more_files]" >&2
	exit
fi

let k=2
file=$(echo "$FILES" | cut -d"'" -f2)
while [ "$file" != "" ]
do
	if [ "$file" != " " ]
	then
		#Aqui es donde se trata cada fichero.
		#En la variable file esta el nombre del
		#fichero sin ''
		#Las iteraciones van de 2 en 2
		echo "$file iteracion $k"
		
		#Check if file or directory exist
		if [ -f "$file" ] || [ -d "$file" ]
		then
			if [ "$uppercase" = "1" ] ; then
				echo "Estoy en upper"
				new_file=$(echo "$file" | tr '[a-z]' '[A-Z]') 
			elif [ "$lowercase" = "1" ] ; then
				echo "Estoy en lowe"
				new_file=$(echo "$file" | tr '[A-Z]' '[a-z]')
			elif [ "$ascii" = "1" ] ; then
				echo "Estoy en ascii"
				new_file=$(echo "$file" | sed -e 's/á/a/g;s/é/e/g;s/í/i/g;s/ó/o/g;s/ú/u/g;s/ñ/n/g;s/Á/A/g;s/É/E/g;s/Í/I/g;s/Ó/O/g;s/Ú/U/g;s/Ñ/N/g;')
			fi
			echo "el nuevo fichero es $new_file"
			if [ "$file" != "$new_file" ]
			then
				mv "$file" "$new_file"
				echo "Codigo devuelto por mv: $?"
			fi	
		else
			echo "File does not exists" >&2
		fi
	fi	
	let k=k+1
	file=$(echo "$FILES" | cut -d"'" -f"$k")
done	

