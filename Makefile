.PHONY: clean separate

MDC=lowdown
MDCFLAGS=-Tlatex --parse-math
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

%-detex.md: %.md
	@count=0; file=$<; cp $< copy-$<; sed -n "/^@l$$/=" $< | awk '{if (NR % 2 == 0) {print $$1} else {printf $$1 "\t" }}' | while read LINE; do \
		start=$$(echo $$LINE | cut -d' ' -f1); \
		end=$$(echo $$LINE | cut -d' ' -f2); \
		sed -n "$${start},$${end}p" $< > $${count}-$<.tex; \
		sed -i "/@l/d" $${count}-$<.tex; \
		sed "$${start},$${end}s/.*/@input{$${count}-$<.tex}/g" copy-$< > copy-$${count}-$<; \
		mv copy-$${count}-$< copy-$< ; \
		count=$$((count + 1)); \
	done
	@count=0; file=$<; sed -n "/@m/=" $< | while read LINE; do \
		sed -n "$${LINE}p" $< > $${count}-math-$<.tex; \
		sed -i -e "s=^[^@]*@m=@m=" -e "s/@m/$$/g" $${count}-math-$<.tex; \
		sed "$${LINE}s/@m.*@m/@input{$${count}-math-$<.tex}/" copy-$< > copy-$${count}-$<; \
		mv copy-$${count}-$< copy-$< ; \
		count=$$((count + 1)); \
	done
	@if grep -E -q "^@p$$" $<; \
	then \
		PREAM=$$(sed -n "/^@p$$/=" $< | awk '{if (NR % 2 == 0) {print $$1} else {printf $$1 "\t" }}'); \
		start=$$(echo $$PREAM | cut -d' ' -f1); \
		end=$$(echo $$PREAM | cut -d' ' -f2); \
		sed -n "$${start},$${end}p" $< > preamble-$<.tex; \
		sed -i "/@p/d" preamble-$<.tex; \
		sed -i "$${start},$${end}s/.*/@pre@preamble-$<.tex@/g" copy-$<; \
	fi;
	@uniq copy-$< > $@
	@rm copy-$<

%-standalone.md: %.md
	@cp $< $@

# When compiling standalone pdfs, add the '-s' flag to MDCFLAGS
%-standalone.tex: MDCFLAGS+=-s

%.tex: %-detex.md
	# replace any underscores(_) with \_; makes integrals and sums work
	#@sed -i -E 's=\\?\_=\\\_=g' $<
	$(MDC) $(MDCFLAGS) $< -o $@
	@sed -i -e "s=@in=\\\\in=" \
	-e 's=\\{={=g' \
	-e 's=\\}=}=g' $@
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

separate: $(SALPDFS) $(SALTEXSRCS) $(SALMDSRCS)

clean:
	@latexmk -c -f $(COMBINEDTEXSRC)
	@latexmk -c -f $(SALTEXSRCS)
	@rm -vf $(TEXSRCS) $(COMBINEDTEXSRC) $(COMBINEDPDF) $(SALPDFS) $(SALTEXSRCS) $(SALMDSRCS) *.tex
