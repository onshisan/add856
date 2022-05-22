#!/bin/bash
# // add856_xml.bash v0.4 ; A script for processing MARCXML files harvested from Archive.org using wget as described here: http://blog.archive.org/2012/04/26/downloading-in/bulk-using-weget 
# // Greg Smith // greg.smith@gmail.com // See README @ http://bit.ly/2oljKPX
# // In future this script may be enhanced to provide for interactive input of item list filename (currently "itemlist.txt", see line 34) and $z display text string (see line 21).
# // For now, both parameters are hard-coded; you may edit them below if necessary to suit your application. See comments in code below for more information.

declare -i insertPoint					# variable to locate 856 tags in each file
declare -i processedItems=0				# variable to count and the number of items processed
declare -i errorItems=0					# variable to count and report the number of items not processed

while IFS='' read -r item || [ -n "$item" ]; do
	
	file="${item}_marc.xml"
	
	[[ ! -f "$file" ]] && continue		# skip bad items (missing files). Could count errors here by incrementing $errorItems. 
	
	insertPoint=$(wc -l < "$file")		# identify location to insert 856 tag based number of lines in the file; trim filename from output of wordcount function and assign to variable
	
	# // multi-line code for MARCXML files
	sed -i "$insertPoint i\  </datafield>" "$file"  # append the closing XML tag for the 856 field
	sed -i "$insertPoint i\    <subfield code=\"z\">Full text available at / Plein texte au site : Archive.org</subfield>" "$file"  # append $z subfield. Edit OPAC display text here if desired.
	sed -i "$insertPoint i\    <subfield code=\"u\">https://archive.org/details/$item</subfield>" "$file" # append $u subfield. Edit base URL here if desired.
	sed -i "$insertPoint i\  <datafield tag=\"856\" ind1=\"4\" ind2=\"0\">" "$file" # append the opening XML tag for the 856 field. Edit indicators here if desired.
	
	echo -e "For identifier '\033[37;44m$item\033[0m' : File is $insertPoint lines : 856 tag appended to '\033[37;41m$file\033[0m'" # show progress via console
	
	((processedItems++))	# increment count of items processed so far
	
done < itemlist.txt

if [ $SECONDS -lt 1 ]		# report total items processed and time elapsed to the nearest second
then
	echo "$processedItems items processed in < 1 second"
else
	echo "$processedItems items processed in $SECONDS second(s)"
fi
