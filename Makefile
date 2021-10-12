SLIDES_PATH=static_files/presentations

KEYS=$(wildcard $(SLIDES_PATH)/*.key)
PDFS=$(addsuffix .pdf,$(basename $(KEYS)))
THUMBS=$(addsuffix .jpg,$(basename $(KEYS)))

slides: $(PDFS) $(THUMBS)

$(SLIDES_PATH)/%.pdf: $(SLIDES_PATH)/%.key
	export/keynote_export.sh -t pdf $<

$(SLIDES_PATH)/%.jpg: $(SLIDES_PATH)/%.pdf
	convert -density 300 -resize %10 \
        	-background white -alpha remove -bordercolor black -border 1 \
        	$<[0] $@

