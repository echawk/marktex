# marktex - a wrapper that allows latex in markdown!

marktex is essentially a wrapper on top of `lowdown` that
allows embedding arbitrary LaTeX commands  into a
markdown document.

To use LaTeX code, wrap your code in '@l' tags.
Like so:

```
@l
\begin{center}
Here is my \LaTeX code
$ and math works \, a^2 + b^2 = c^2 $
\end{center}
@l
```

~~To use just the math mode of LaTeX, you can wrap your code in '@m' tags instead:~~

```
@m \int_a^b f(t) @m
```
Update: I've come to find out about lowdown's `--parse-math` flag, so that is used instead now.


Most things will typically *just work*.
Currently the only exception to this is if you need external packages,
as I have not yet implemented support for changing the preamble of the document.

And all you need to do is copy the Makefile in this directory
into your note directory, and you're good to go.

I do plan on adding a generic shell script in the future.

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
* awk
* uniq
* grep
* latexmk (used for the clean rule)
* source-highlight

## TODO
- [ ] Rename `marktex` to something more broad, since I don't want a hard dependency on LaTeX
	- I'm thinking `lmdc` as a possible alternative, but I think the name should have a vowel
- [ ] Refactor `marktex` to be easier to follow; don't use as many compound variable names...
	- [ ] extract the different parsers to their own scripts
		- **NOTE:** Right now I'm am putting this on hold; I'll start work on this once marktex is completed
- [ ] Consider changing the extension to represent that this isn't typical markdown; I'm thinking `.lmd`
	- I think this extension is appropriate considering marktex's use case and origin: using LaTeX to extend markdown and literate programming
- [x] Add in support for the preamble
	- The preamble is tested well in the 'marktex' script, however it has not been throughly tested with the makefile
- [ ] Add in support to change the document class (ideally in the preamble section)
- [ ] Add in support for citation commands
	- Using miktex, there seems to be an issue with biber
- [x] Add in support for highlighting source code
	- I'd like to be able to use marktex for literate programming
	- `source-highlight` will likely fit my needs
- [x] Extract the commands to an external shell script (while still keeping it embedded in the makefile)
	- This is currently what the `marktex` shell script does; it's where the main development is occuring
- [x] Support proper inline math with the '@m' tags
	- We don't have to support this ourselves; lowdown already offers a '--parse-math' flag to hande this.

### Long Term
- Reduce the dependence on LaTeX; add in the ability to use groff instead
	- This should be relatively straightforward, however I don't want to start this process until marktex is sufficently stable

## Issues
- Currently there is no way to tell lowdown about context
	- this issue could be avoided by splitting up the document into separate parts, and then merging them together again
	- @l tokens to designate latex context? sed -n gets line numbers
	- Below is a proof of concept
		-  `sed -n "/^@l$/=" l.md | awk '{if (NR % 2 == 0) {print $1} else {printf $1 "\t" }}' | while read LINE; do start=$(echo $LINE | cut -d' ' -f1); end=$(echo $LINE | cut -d' ' -f2); sed -n "${start},${end}p" l.md; sed "${start},${end}s/.*/.latex/g" l.md; sed "s=\.latex=\.l" l.md ; done`



