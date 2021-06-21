# marktex's format

This document will describe the extensions to
markdown that marktex uses, so that other's may
reimplement what I have written here.

marktex uses different tags, all starting with an
'@' symbol. This is for ease of typing, as well as
being an unused symbol in most markup langauges.

## LaTeX Blocks

To denote a LaTeX context, use '@l' tokens like so:

```
@l
\begin{center}
Here is some example text
\end{center}
@l
```

It is important to note that these tokens behave in the
same way that groff tokens work; they must be at the
start of the line.

## Preamble Block

There can only ever be **1** Preamble block in a document.
This is to replicate LaTeX's style.

Preamble blocks are structured the same way as LaTeX blocks,
except they replace the '@l' with an '@p':

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

TODO: Figure this out

### Current Idea

Wrap code blocks like so:
	```{py}{optionalfile}
	def fun(n):
	return n * n
	```


