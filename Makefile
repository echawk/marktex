.PHONY: clean standalone

MDC=lowdown
MDCFLAGS=-Tlatex
TEXCC=pdflatex
MDSRCS=$(wildcard *.md)
TEXSRCS=$(MDSRCS:.md=.tex)
TEXPKGS=tikz xcolor geometry amsmath
SALMDSRCS=$(MDSRCS:.md=-standalone.md)
SALTEXSRCS=$(SALMDSRCS:.md=.tex)
SALPDFS=$(SALTEXSRCS:.tex=.pdf)
COMBINEDTEXSRC=combined.tex
COMBINEDPDF=$(COMBINEDTEXSRC:.tex=.pdf)

all: $(COMBINEDPDF)

%-standalone.md: %.md
	@cp $< $@

# When compiling standalone pdfs, add the '-s' flag to MDCFLAGS
%-standalone.tex: MDCFLAGS+=-s

%.tex: %.md
	# replace any underscores(_) with \_; makes integrals and sums work
	#@sed -i -E 's=\\?\_=\\\_=g' $<
	$(MDC) $(MDCFLAGS) $< -o $@
	@sed -i -e "s=@m=$$=g" \
	-e 's=\\{={=g' \
	-e 's=\\}=}=g' \
	-e 's=\\_=_=g' \
	-e 's=textbackslash{}==g' \
	-e 's=\\textasciicircum{}=^=g' \
	-e 's=\\textsuperscript=^=g' \
	-e 's=sum\\emph{=sum_=g' \
	-e 's~\\\&=~\&=~g' $@
	#@grep '\documentclass{' && { for pkg in $(TEXPKGS); do; pkgline="$$pkgline \n\usepackage{$$pkg}" done; sed -E "s~(\documentclass{.*})~\1$$pkgline~"};

%.pdf: %.tex
	$(TEXCC) $<

$(COMBINEDTEXSRC): $(TEXSRCS)
	@echo '\documentclass{article}' > $(COMBINEDTEXSRC);
	@echo >> $(COMBINEDTEXSRC);
	@for pkg in $(TEXPKGS); do \
		echo "\usepackage{$$pkg}" >> $(COMBINEDTEXSRC); \
	done
	@printf "%s\n" "\begin{document}" >> $(COMBINEDTEXSRC);
	@for src in $(TEXSRCS); do \
		echo "\input{$$src}" >> $(COMBINEDTEXSRC); \
	done
	@echo "\end{document}\n" >> $(COMBINEDTEXSRC);

standalone: $(SALPDFS) $(SALTEXSRCS) $(SALMDSRCS)

clean:
	@latexmk -c -f $(COMBINEDTEXSRC)
	@latexmk -c -f $(SALTEXSRCS)
	@rm -vf $(TEXSRCS) $(COMBINEDTEXSRC) $(COMBINEDPDF) $(SALPDFS) $(SALTEXSRCS) $(SALMDSRCS)
