.PHONY: install serve drafts build check

install:
	bundle install

serve:
	bundle exec jekyll serve --livereload

drafts:
	bundle exec jekyll serve --livereload --drafts

build:
	JEKYLL_ENV=production bundle exec jekyll build

check: build
	ruby scripts/check.rb
