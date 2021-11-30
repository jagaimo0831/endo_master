TARGET= main
# tuatmech-master-chukan-template
# tuatmech-master-chukan-template 
# soturon-maezuri-template 
#TARGETに指定されたものがmakeされる．不要なものはコメントアウトしよう．

# set below the directory in which your figs are placed
FIGDIR=./fig

DVI=$(addsuffix .dvi,$(TARGET))
PDF=$(addsuffix .pdf,$(TARGET))

# If you prefer to compile to pdf, replace $(DVI) below by $(PDF)
all: $(DVI)

pdf: $(PDF)

show: $(addsuffix .show,$(TARGET))

OS=$(shell uname | cut -d_ -f1)

ifneq ($(OS),CYGWIN)
PLATEX=platex -kanji=utf8 -shell-escape
JBIBTEX=pbibtex -kanji=utf8
DVIPDFM=dvipdfmx
endif

ifeq ($(OS),CYGWIN)
PLATEX=platex -kanji=utf8
JBIBTEX=pbibtex -kanji=utf8
# JBIBTEX=jbibtex -kanji=euc
DVIPDFM=dvipdfmx
EXE=.exe
endif

%.dvi: %.tex
	(cd $(FIGDIR); ebb *.jpg *.JPG *.gif)
	$(PLATEX) $*
	$(JBIBTEX) $*
	$(PLATEX) $*
	$(PLATEX) $*
	grep War $*.log | cat

%.show: %.pdf
ifeq ($(OS),CYGWIN)
	cygstart $<
else
	gnome-open $<
endif

%.pdf: %.dvi out2uni$(EXE)
	./out2uni$(EXE) -e $*
	$(PLATEX) $*
	$(DVIPDFM) $<

out2uni$(EXE): out2uni.c
	gcc -O $< -o $@

*.pdf: ./out2uni$(EXE)

clean:
	rm -f $(DVI)
	rm -f *.aux *.log *.blg *.bbl *.toc *.out
	rm -f $(PDF)
	rm -f out2uni$(EXE) *.out
	rm -f $(FIGDIR)/*.bb

main.dvi: *.tex

soturon-maezuri-template.dvi: soturon-maezuri-template.tex tuatmech-final.tex

tuatmech-chukan-template.pdf: tuatmech-chukan-template.dvi
	$(PLATEX) tuatmech-chukan-template
	$(DVIPDFM) $<

tuatmech-master-chukan-template.pdf: tuatmech-master-chukan-template.dvi
	$(PLATEX) tuatmech-master-chukan-template
	$(DVIPDFM) $<

main.pdf: main.dvi
	$(PLATEX) main 
	$(DVIPDFM) $<

soturon-maezuri-template.pdf: soturon-maezuri-template.dvi
	$(PLATEX) soturon-maezuri-template 
	$(DVIPDFM) $<
