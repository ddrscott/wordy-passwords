build_dir:=build
dist_dir:=dist
book_texts=$(shell awk '{print "$(build_dir)/" $$0 ".txt" }' $(build_dir)/book_ids)
book_words=$(shell awk '{print "$(build_dir)/" $$0 ".wds" }' $(build_dir)/book_ids)

$(build_dir):
	mkdir -p $@

$(dist_dir):
	mkdir -p $@

$(build_dir)/pg_catalog.csv: | $(build_dir)
	curl --fail https://www.gutenberg.org/cache/epub/feeds/pg_catalog.csv > $@

$(build_dir)/book_ids: $(build_dir)/pg_catalog.csv | $(build_dir)
	grep -oP '^[0-9]+(?=,Text,.+,en,.+Doyle, Arthur Conan.+Fiction)' $^ > $@

$(build_dir)/%.txt: $(build_dir)/book_ids
	curl --fail "https://www.gutenberg.org/files/$*/$*.txt"   -o $@ || \
	curl        "https://www.gutenberg.org/files/$*/$*-0.txt" -o $@

$(build_dir)/%.wds: $(build_dir)/book_ids $(book_texts)
	grep -oE '\b[a-z]{3,}\b' $(build_dir)/$*.txt | sort -u > $@

$(dist_dir)/words: $(build_dir)/book_ids $(book_words) | $(dist_dir)
	cat $(book_words) | sort -u > $@

passwd: $(dist_dir)/words
	@shuf -n4 $(dist_dir)/words | paste -sd- -

.PRECIOUS: $(build_dir)/%.txt
.DEFAULT_GOAL := $(dist_dir)/words
