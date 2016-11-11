PACKAGE_NAME := bioacoustica
R_PDF := $(PACKAGE_NAME).pdf
R_DIR = $(shell pwd)
R_SOURCES := $(shell ls $(R_DIR)/R/*.R )
N = $(shell cat $(R_DIR)/DESCRIPTION |grep ^Package | cut --fields=2 --delimiter=: |sed s/\ //g)
V := $(shell cat $(R_DIR)/DESCRIPTION |grep ^Version  | cut --fields=2 --delimiter=: |sed s/\ //g)
R_TGZ := $(N)_$(V).tar.gz
R_PDF := $(N).pdf
vpath %.R  $(R_DIR)


all: check README.md $(R_PDF) R

README.md : README.Rmd
	@echo "Knitting README"
	@echo "library(knitr); knit(input=\"$<\", output=\"$@\")"| R --vanilla


R : $(R_TGZ)  
	@echo "installing Package"
	R CMD INSTALL $(R_TGZ)


$(R_PDF) : $(R_SOURCES) 
	R CMD Rd2pdf --force . -o $@

$(R_TGZ) : $(R_SOURCES) README.md
	@echo "Roxygenising:"
	@echo $(R_SOURCES)
	@echo "library(roxygen2); roxygenise()" | R --vanilla
	@echo "Building Package $(R_TGZ):"
	@R CMD build .

check: $(R_TGZ)
	R CMD check --as-cran $<

clean:
	rm -fr *.tar.gz *.out *.pdf *.log README.md README_CACHE README_files *cache* .Rd2pdf* figure/

