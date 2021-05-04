# marktex - a Makefile that allows latex in markdown!

marktex is essentially a wrapper on top of `lowdown` that
allows embedding latex commands (namely math mode) into a
markdown document.

There are a few catches though, first you will have to make
sure that you write your LaTeX commands in such a way that
lowdown won't screw them up.

Some examples:
* changing '\_' to '\\\_' in your `\\int` and `\\sum` lines
* changing '\*' to '\\\*' for your equation contexts
* etc...


But most things will typically *just work*.


And all you need to do is copy the Makefile in this diretory
into your note directory, and you're good to go.

## Usage
To make a cumulative pdf, just run `make`

However, if you want each markdown file to be it's own
pdf file, you can run `make separate` instead.

To get rid of all of the generated files, run `make clean`

## Dependencies
* lowdown
* pdflatex
* gnu make
* sed with the '-i' flag
* latexmk (used for the clean rule)


## Issues
- Currently there is no way to tell lowdown about context
	- this issue could be avoided by splitting up the document into separate parts, and then merging them together again
	- @l tokens to designate latex context? sed -n gets line numbers
	- Below is a proof of concept
		-  `sed -n "/^@l$/=" l.md | awk '{if (NR % 2 == 0) {print $1} else {printf $1 "\t" }}' | while read LINE; do start=$(echo $LINE | cut -d' ' -f1); end=$(echo $LINE | cut -d' ' -f2); sed -n "${start},${end}p" l.md; sed "${start},${end}s/.*/.latex/g" l.md; sed "s=\.latex=\.l" l.md ; done`



