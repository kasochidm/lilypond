# cancel the rule that generates .n[o lilypond images t]exi files
$(outdir)/%.nexi: $(ITELY_FILES) $(ITEXI_FILES)

$(outdir)/%/index.html: $(outdir)/%.texi
	mkdir -p $(dir $@)
	-$(MAKEINFO) -P $(outdir) --output=$(outdir)/$* --css-include=$(top-src-dir)/Documentation/texinfo.css --html $<

$(outdir)/%-big-page.html: $(outdir)/%.texi
	-$(MAKEINFO) -P $(outdir) --output=$@ --css-include=$(top-src-dir)/Documentation/texinfo.css --html --no-split --no-headers $< 

$(outdir)/%.pdftexi: $(outdir)/%.texi doc-po
	$(PYTHON) $(buildscript-dir)/texi-gettext.py $(buildscript-dir) $(top-build-dir)/Documentation/po/$(outdir) $(ISOLANG) $<

$(outdir)/%.pdf: $(outdir)/%.pdftexi
	cd $(outdir); texi2pdf $(TEXI2PDF_FLAGS) $(TEXINFO_PAPERSIZE_OPTION) $(notdir $*).pdftexi
