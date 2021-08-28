# marktex's format

This document will describe the extensions to
markdown that marktex uses, so that other's may
reimplement what I have written here.

marktex uses different tags, all starting with an
'@' symbol. This is for ease of typing, as well as
being an unused symbol in most markup langauges.

## Raw Blocks

To denote a raw context, use '@r' tokens like so:

```
@r
\begin{center}
Here is some example text
\end{center}
@r
```

It is important to note that these tokens behave in the
same way that groff tokens work; they must be at the
start of the line.

The text written between the two tokens will be copied
directly into the final document.

## Preamble Block

There can only ever be **1** Preamble block in a document.
This is to replicate LaTeX's style.

Preamble blocks are structured the same way as raw blocks,
except they replace the '@r' with an '@p':

```
@p
\usepackage{examplepackage}
\usepackage[options]{package2}
@p
```

## Citation Commands

Citation commands are done *inline*, so you can include them
anywhere in the text. The token they use is the '@c' token.
Here's an example:

```
Here is a sentence that I would like to cite@cCitationRef, 41@c.
```

And an example making clear where the citation command is:

```
The quick brown fox jumped over the lazy hare
@c CitationRef, 42 @c
.
```

## Code Blocks

To embed code in your markdown file, write it in this format:

	```>lang>optionalfile
	def fun(n):
		return n * n
	```>

Where `lang` is a language available from source-highlight, and
`optionalfile` is an optional file for your code to be sent to.
The `optionalfile` will be created on the fly; it's assumed to
be nonexistent at runtime.

If you don't want to program directly in the `.lmd` file, you can
instead have your code read in at compile time by using this
format instead:

	sourcefile>```>lang

