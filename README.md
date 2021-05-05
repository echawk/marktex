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

To use just the math mode of LaTeX, you can wrap your code in '@m'
tags instead:

```
@m \int_a^b f(t) @m
```

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
* latexmk (used for the clean rule)


## TODO
- [ ] Add in support for the preamble
- [ ] Extract the commands to an external shell script (while still keeping it embedded in the makefile)
- [ ] Support proper inline math with the '@m' tags

## Issues
- Currently there is no way to tell lowdown about context
	- this issue could be avoided by splitting up the document into separate parts, and then merging them together again
	- @l tokens to designate latex context? sed -n gets line numbers
	- Below is a proof of concept
		-  `sed -n "/^@l$/=" l.md | awk '{if (NR % 2 == 0) {print $1} else {printf $1 "\t" }}' | while read LINE; do start=$(echo $LINE | cut -d' ' -f1); end=$(echo $LINE | cut -d' ' -f2); sed -n "${start},${end}p" l.md; sed "${start},${end}s/.*/.latex/g" l.md; sed "s=\.latex=\.l" l.md ; done`



