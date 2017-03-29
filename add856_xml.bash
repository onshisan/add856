#!/bin/bash
# // add856_mrk.bash v0.3 ; A simple script for processing MARCXML files harvested from Archive.org using wget as described here: http://blog.archive.org/2012/04/26/downloading-in/bulk-using-weget 
# // Greg Smith // greg.smith@justice.gc.ca // greg.smith@gmail.com

# // ABOUT
# //
# // Quickly construct a basic MARC 856 tag within each file in a batch previously harvested from the Internet Archive.
# // This is accomplished by inserting each item's "identifier" string, read from a separately generated file.
# // NB: Output may require further processing to ensure full MARCXML compliance.
# // See Library of Congress MARC 21 bibliographic format spec, esp. http://www.loc.gov/marc/bibliographic/bd856.html for background.

# // METHOD
# //
# // 1)	Obtain a CSV for the items of interest to you using IA's advanced search template here: https://archive.org/advanced.search.php
# // 2)	Using a text editor, delete "identifier" from the first row and re-name the file "itemlist.txt" for use with this script.
# // 3)	Save itemlist.txt with Unix end-of-line (EOL) or otherwise convert it if you are text-editing on a Windows machine.
# // 		If your text editor does not support EOL conversion, see suggestions here: https://kb.iu.edu/d/acux
# // 4)	Harvest .mrc files for the set of items defined by itemlist.txt using wget at the Bash command prompt as follows: 
# //		$ wget -r -H -nc -np -nH --cut-dirs=1 -A .mrc -e robots=off -l1 -i itemlist.txt -B 'http://archive.org/download/'
# // 		Adjust "-A" flag parameters to download other file formats (e.g., .xml, txt, .pdf) at the same time if you wish to obtain the full-text of each item from Archive.org along with its metadata.
# // 		Depending on the length of your itemlist.txt file and your connection speed, this step may take minutes, hours, or days to complete.
# // 5) Batch process .mrc files to .mrk format using MarcEdit, available here: http://marcedit.reeset.net/downloads
# //		MarcEdit saves the new .mrk files in a sub-directory called "/processed_files"; you may wish with copy the script and itemlist.txt there before continuing.
# // 		Alternatively, move the files to the same location as the script and itemlist.txt.
# // 6)	Review and edit $z subfield display text in line 27 below to meet your needs.
# // 7) Run this script at the Bash command prompt in the /processed_files directory or wherever the .mrk files and itemlist.txt reside.
# //		Tip: If the script runs but unexpectedly processes 0 records, double-check to ensure that itemlist.txt has been saved with Unix EOL as discussed in (3) above.
# // 8) Open an arbitrarily-selected .mrk file in MarcEdit and validate to ensure there are no issues before proceeding. Consider making any necessary revisions through batch processing.
# // 9) Merge and/or convert .mrk files to .mrc or other file format(s) as desired for further processing or OPAC import. 

# // TEST COMMANDS
# // At the Bash command prompt, enter the following to familiarize yourself with the script. 
# // Always run the script from the same directory as itemlist.txt and the batch of .mrk files to be processed.
# //
# // Generate a set of 1000 test files:
# // 	$ touch {1..1000}_meta.mrk
# // Generate itemlist.txt based on the .mrk files in your working directory, then strip "_meta" from each row to format for processing:
# // 	$ ls -1 *.mrk | sed -e 's/\..*$//' | cat > itemlist.txt; sed -i 's/_meta//g' itemlist.txt
# // Run script:
# // 	$ bash add856_mrk.bash
# // View 856 tag appended to randomly-chosen file from test batch:
# // 	$ luckyRoll=$(shuf i 1-1000 -n 1); cat $luckyRoll_meta.mrk
# // Delete test files:
# // 	$ rm {1..1000}_meta.mrk
# //	$ rm itemlist.txt

# // 856 TAG APPENDING SCRIPT
# // In future this script may be enhanced to provide for interactive input of item list filename and $z display text string.
# // For now, both parameters are hard-coded; you may edit them below if necessary to suit your application.

declare insertPoint																										# declare variable to set insertion point for 856 tag in each file
declare -i processedItems=0																								# declare variable to count and the number of items processed
# declare -i errorItems=0																								# [not implemented] declare variable to count and report the number of items not processed

while IFS='' read -r item || [ -n "$item" ]; do
	
	file="${item}_marc.xml"
	
	[[ ! -f "$file" ]] && continue																						# skip bad items / missing files (add error reporting by incrementing $errorItems here?) 
	
	insertPoint=$(wc -l "$file")																						# identify location to insert 856 tag based number of lines in the file
	# insertPoint=${"$insertPoint":0:2}
	echo $insertPoint "input"	#report value of insertPoint for debugging
	$insertPoint= ${insertPoint%%$file}
	echo $insertPoint "output"
	# echo ${insertPoint:0:3}
	# // multi-line code for MARCXML files
	#sed -i '$insertPointi\ <datafield tag=\"856\" ind1=\"4\" ind2=\"0\">' "$file" 										# append the opening XML tag for the 856 field. Edit indicators here if desired.
	#awk -v n=$insertPoint -v s="  <datafield tag=\"856\" ind1=\"4\" ind2=\"0\">" 'NR == n {print s} {print}' $file > output.xml
	
	# echo "    <subfield code=\"u\">https://archive.org/details/$item</subfield>" >> "$file" 							# append $u subfield. Edit base URL here if desired.
	# echo "    <subfield code=\"z\">Full text available at / Plein texte au site : Archive.org</subfield>" >> "$file" 	# append $z subfield. Edit OPAC display text here if desired.
	# echo "  </datafield>" >> "$file" 																					# append the closing XML tag for the 856 field
	
	# // multi-line echo code for MARCXML files
	# echo "  <datafield tag=\"856\" ind1=\"4\" ind2=\"0\">" >> "$file" 												# append the opening XML tag for the 856 field. Edit indicators here if desired.
	# echo "    <subfield code=\"u\">https://archive.org/details/$item</subfield>" >> "$file" 							# append $u subfield. Edit base URL here if desired.
	# echo "    <subfield code=\"z\">Full text available at / Plein texte au site : Archive.org</subfield>" >> "$file" 	# append $z subfield. Edit OPAC display text here if desired.
	# echo "  </datafield>" >> "$file" 																					# append the closing XML tag for the 856 field
	
	# // single-line echo code for .mrk/.mrc files
	# echo "=856  40\$uhttps://archive.org/details/$item\$zFull text available at / Plein texte au site : Archive.org" >> "$file"		# append the identifier to the file (add code to insert user input here later; $z subfield hard-coded for now)
	
	echo -e "For identifier '\033[37;44m$item\033[0m' : 856 tag appended to '\033[37;41m$file\033[0m'" 					# report progress onscreen
	
	((processedItems++))																								# increment count of items processed so far
	
done < itemlist.txt

# report total items processed and time elapsed
if [ $SECONDS -lt 1 ]
then
	echo "$processedItems items processed in < 1 second"
else
	echo "$processedItems items processed in $SECONDS second(s)"
fi
