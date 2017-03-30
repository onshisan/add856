# // add856

A simple Bash script to add 856 field tags to MARC records harvested from [Archive.org](http://archive.org).

Current status: add856_xml.bash is minimially functional. Some parameters that you may wish to edit are hard-coded; review documentation below as well as comments in the source code before processing your harvested metadata.


# // ABOUT

This is a specialized tool meant to quickly construct a basic MARC 856 tag within each file in a batch.

It was designed for metadata harvested from the Internet Archive as described here:
> http://blog.archive.org/2012/04/26/downloading-in/bulk-using-weget 

Please note that add 856's output may require further processing to ensure full MARCXML / MARC-21 format compliance.

Be sure to backup, verify, validate, and spot-check your output before proceeding!

See Library of Congress' [MARC 21 bibliographic format](http://www.loc.gov/marc/bibliographic/) spec, especially [regarding the 856 field tag](http://www.loc.gov/marc/bibliographic/bd856.html) for background.

# // METHOD

1)	Obtain a CSV for the items of interest to you using [Archive.org's advanced search template](https://archive.org/advanced.search.php) here:</b>
> https://archive.org/advanced.search.php

2)	Using a text editor, delete "identifier" from the first row and re-name the file "itemlist.txt" for use with this script.

3)	Save itemlist.txt with Unix end-of-line (EOL) or otherwise convert it if you are text-editing on a Windows machine. If your text editor does not support EOL conversion, see [suggestions](https://kb.iu.edu/d/acux) here:
> https://kb.iu.edu/d/acux

4)	Harvest .mrc files for the set of items defined by itemlist.txt using wget at the Bash command prompt as follows:
```shell
$ wget -r -H -nc -np -nH --cut-dirs=1 -A .mrc -e robots=off -l1 -i itemlist.txt -B 'http://archive.org/download/'
``` 
You can adjust "-A" flag parameters to download other file formats (e.g., .xml, txt, .pdf) at the same time. In this way you may obtain the full-text of each item from Archive.org along with its metadata if you wish.

<i><b>NB</b>: Depending on the length of your itemlist.txt file and your connection speed, this may take a <u>long</u> time!</i>

5)  Batch process .mrc files to .mrk format using [MarcEdit](http://marcedit.reeset.net/downloads): 
> http://marcedit.reeset.net/downloads
        
MarcEdit saves the new .mrk files in a sub-directory called "/processed_files". You may wish with copy the script and itemlist.txt there before continuing. Alternatively, move the files to the same location as the script and itemlist.txt.

6)  Review and edit $z subfield display text in line 27 below to meet your needs.

7)  Run this script at the Bash command prompt in the /processed_files directory.

Alternatively, run it wherever the batch of .mrk files and your itemlist.txt file reside.

Tip: If the script runs but unexpectedly processes 0 records, double-check itemlist.txt has Unix EOL (See (3) above!) and contains identifiers corresponding to your batch of metadata files.

8) Open an arbitrarily-selected .mrk file in MarcEdit and validate to ensure there are no issues before proceeding. Consider making any necessary revisions through batch processing using MarcEdit.

9) Merge and/or convert .mrk files to .mrc or other file format(s) as desired for further processing or OPAC import.

10) Enjoy your freshly 856'd MARC!


# // TEST COMMANDS

At the Bash command prompt, enter the following to familiarize yourself with the .mrk version of add856. 

Always run the script from the same directory as itemlist.txt and the batch of .mrk files to be processed.

1) Generate a set of 1000 test files:

```sh
$ touch {1..1000}_meta.mrk
```


2) Generate itemlist.txt based on the .mrk files in your working directory, then strip the "_meta" suffix from each row to match Archive.org's identifier list / CSV output format for processing:

```sh
$ ls -1 *.mrk | sed -e 's/\..*$//' | cat > itemlist.txt; sed -i 's/_meta//g' itemlist.txt
```


3) Run script using test files:

```sh
$ bash add856_mrk.bash
```


4) Display contents of randomly-chosen file from test batch for verification:

```sh
$ luckyRoll=$(shuf -i 1-25 -n 1); echo "File number "$luckyRoll; cat ${luckyRoll}_meta.mrk
```


5) Delete set of test files (if you modified the set size in step one, do the same here):

```sh
$ rm {1..1000}_meta.mrk; rm itemlist.txt
```

To test the .xml version of add856, substitute `_marc.xml`, `_marc`, and `.xml` for `_meta.mrk`, `_meta` and `.mrk` throughout the commands shown above (e.g. `$ touch {1..1000}_marc.xml`).



