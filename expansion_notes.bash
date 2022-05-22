#!/bin/bash

#TEST SET 1
declare foo="superstring"
echo
echo "Whole string: " $foo
echo "Length of string: " ${#foo}
echo "Susbstring: " ${foo:5:3}

# TEST SET 2
foo=$(wc -l itemlist.txt)
echo
echo "Whole string: " $foo	    	# echo input
echo "Length of string: " ${#foo}	#echo length of foo
# echo `expr substr $foo 1 2`

foo=$(wc -1 > itemlist.txt)       # see: http://stackoverflow.com/questions/12022319/bash-echo-number-of-lines-of-file-given-in-a-bash-variable-without-the-file-name
echo "Whole string: " $foo		    # echo output

# NOTES
