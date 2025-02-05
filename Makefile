#!/usr/bin/env bash

# Publishing variables
SERVER=dreamarticles
WEBSITE=articles.chymera.eu
NAME=$(shell basename $(shell pwd))


# Set NOCLIENT variable to not prepend hostname to published filename:
# e.g. `NOCLIENT=1 make upload-article`
CLIENT := $(if $(NOCLIENT),$(shell cat /dev/null),$(shell hostname)_)

COMMON := bib.bib common_header.tex
PYTHONTEX_ALL := $(wildcard lib/* pythontex/* scripts/*)
STATIC_ALL := $(wildcard img/* *.sty)

all: article.pdf poster.pdf pitch.pdf slides.pdf

article.pdf:	$(wildcard article/*) $(COMMON) $(PYTHONTEX_ALL) $(STATIC_ALL)
	rubber --pdf --unsafe article.tex
pitch.pdf:		$(wildcard pitch/*) $(COMMON) $(PYTHONTEX_ALL) $(STATIC_ALL)
	rubber --pdf --unsafe pitch.tex
poster.pdf:	$(wildcard poster/*) $(COMMON) $(PYTHONTEX_ALL) $(STATIC_ALL)
	rubber --pdf --unsafe poster.tex
slides.pdf:		$(wildcard slides/*) $(COMMON) $(PYTHONTEX_ALL) $(STATIC_ALL)
	rubber --pdf --unsafe slides.tex


# Cleanscripts
clean-article:
	rubber --clean article.tex
	rm _minted-article -rf
clean-pitch:
	rubber --clean pitch.tex
	rm _minted-pitch -rf
clean-poster:
	rubber --clean poster.tex
	rm _minted-poster -rf
clean-slides:
	rubber --clean slides.tex
	rm _minted-slides -rf
clean-traces:
	rm -rf\
		auto_fig_py_*\
		*.aux\
		*.bbl\
		*.blg\
		*.log\
		*.nav\
		*.out\
		*.pgf\
		pythontex-files-*\
		*.pytxcode\
		*.snm\
		*.toc\
		*.vrb\
		*.rubbercache
clean: cleanarticle cleanpitch cleanposter cleanslides
clean-full: cleanarticle cleanpitch cleanposter cleanslides cleantraces

# Upload scripts
upload: upload-article
upload-article: article.pdf
	rsync -avP article.pdf ${SERVER}:${WEBSITE}/${CLIENT}${NAME}_article.pdf
upload-pitch: pitch.pdf
	rsync -avP pitch.pdf ${SERVER}:${WEBSITE}/${CLIENT}${NAME}_pitch.pdf
upload-poster: poster.pdf
	rsync -avP poster.pdf ${SERVER}:${WEBSITE}/${CLIENT}${NAME}_poster.pdf
upload-slides: slides.pdf
	rsync -avP slides.pdf ${SERVER}:${WEBSITE}/${CLIENT}${NAME}_slides.pdf
