#!/bin/bash

# Gardian Angel is meant to be an alternative to the rm command.
# Instead of deindexing the files, it simply move them to the wastebin.

Trash="$HOME/.local/share/Trash/files/"
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`



# Error in case the file does not exist 
file_not_found(){
	if [ ! -f $1 ]; then 
		echo "${red}[Error] : ${reset} File not found"
	fi
}


# Error in case of no argument provided 
no_argument_provided(){
    echo "${red}[Error] : ${reset}You didn't specified a file."
    echo 'Command example : rm file1.txt'
    exit 2
}

# Print Usage 
usage(){
	echo 'Usage : '
	echo ' -r : remove folder '
	echo ' -f : ignore prompt'
	echo ' -h : print this help page'
}

rm_classique(){

	while (( `expr $# - 1` )); do 
		mv $2 $Trash 
		shift
	done

}

rm_classique_no_arguments(){
	while (( $# )); do 
		mv $1 $Trash 
		shift
	done
}

rm_with_no_warning(){


	while (( `expr $# - 1` )); do 
		mv --force $2 $Trash 
		shift
	done


}

# rm_with_warning
rm_with_warning(){


	echo 'Do you wish to move' "${@:2}" 'to trash ? [y/n] '
	read answer 
	
	if [[ ${answer:0:1} =~ [yY] ]]; then  
		while (( `expr $# - 1` )); do 
			mv -i $2 $Trash 
			shift
		done
	else 
		echo 'understandable, have a great day !'
		exit 0
	
	fi 

}


# getopt to get the arguments 

while getopts "hf:i:r:" OPTION; do
    case $OPTION in
    h)
	usage
	;;
    f)
	rm_with_no_warning $@
	;;
    i)
	rm_with_warning $@
	;;
    r)
	rm_classique $@
	;;
    *)
	echo "Incorrect options provided"
	exit 1
	;;
    esac
done


# main method if no flags are provided  

while (( $# )); do 
	if [ ! -f $1 ]; then 
		echo "${red}[Error] : ${reset}File not found" 
		exit 1
	else	
		mv $1 $Trash
	fi
	shift
done 

exit 0 

# print error if no arguments/files are provided
# if [ $# -lt 1 ]; then 
# 	no_argument_provided
# 	exit 1
# fi 


